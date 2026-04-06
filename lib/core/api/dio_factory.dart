import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:gym_management_app/core/api/api_constants.dart';
import 'package:gym_management_app/core/api/api_service.dart';
import 'package:gym_management_app/core/api/refresh_token_model.dart';
import 'package:gym_management_app/core/helpers/app_navigator.dart';
import 'package:gym_management_app/core/routing/routers.dart';
import 'package:gym_management_app/feature/login/data/model/login_response_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:gym_management_app/core/storage/shared_pref_helper.dart';
import 'package:gym_management_app/core/storage/shared_pref_keys.dart';

class DioFactory {
  static bool _isRefreshing = false;
  static final List<QueueItem> _queue = [];

  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);
    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptor() {
    dio?.interceptors.addAll([
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip auth header for login and refresh token endpoints
          final isAuthEndpoint =
              options.path.contains(ApiConstants.login) ||
              options.path.contains(ApiConstants.refreshToken);

          if (!isAuthEndpoint) {
            final token = await SharedPrefHelper.getSecuredString(
              SharedPrefKeys.userToken,
            );
            if (token.isNotEmpty) {
              options.headers["Authorization"] = "Bearer $token";
            }
          }

          // Set accept language header
          options.headers['Accept-Language'] =
              navigatorKey.currentContext?.locale.languageCode ?? 'en';

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Handle successful responses
          handler.next(response);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final requestOptions = error.requestOptions;

          // Debug logging
          if (kDebugMode) {
            debugPrint("DIO ERROR TYPE: ${error.type}");
            debugPrint("DIO ERROR: ${error.error}");
            debugPrint("DIO MESSAGE: ${error.message}");
            debugPrint("DIO STATUS CODE: $statusCode");
            debugPrint("DIO PATH: ${requestOptions.path}");
          }

          // Handle 401 Unauthorized errors
          if (statusCode == 401) {
            // Check if it's a refresh token request to avoid infinite loop
            if (requestOptions.path.contains(ApiConstants.refreshToken)) {
              if (kDebugMode) {
                debugPrint("Refresh token failed, logging out...");
              }
              await _logoutAndNavigateToLogin();
              return handler.next(error);
            }

            // Check if it's a login request - should not retry
            if (requestOptions.path.contains(ApiConstants.login)) {
              return handler.next(error);
            }

            // Get refresh token
            String refreshToken = await SharedPrefHelper.getSecuredString(
              SharedPrefKeys.refreshToken,
            );

            if (refreshToken.isEmpty) {
              // No refresh token available, logout
              if (kDebugMode) {
                debugPrint("No refresh token, logging out...");
              }
              await _logoutAndNavigateToLogin();
              return handler.next(error);
            }

            // If already refreshing, add to queue
            if (_isRefreshing) {
              if (kDebugMode) {
                debugPrint(
                  "Already refreshing, adding request to queue: ${requestOptions.path}",
                );
              }
              final completer = Completer<Response>();
              _queue.add(QueueItem(requestOptions, completer));
              return completer.future.then(
                (response) => handler.resolve(response),
                onError: (e) => handler.next(e as DioException),
              );
            }

            // Start refresh process
            _isRefreshing = true;

            try {
              if (kDebugMode) {
                debugPrint("Starting token refresh...");
              }

              // Call refresh token API
              final response = await _refreshToken(refreshToken);
              final newAccessToken = response.token;
              final newRefreshToken = response.refreshToken;

              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                // Save new tokens
                await SharedPrefHelper.setSecuredString(
                  SharedPrefKeys.userToken,
                  newAccessToken,
                );
                if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
                  await SharedPrefHelper.setSecuredString(
                    SharedPrefKeys.refreshToken,
                    newRefreshToken,
                  );
                }

                if (kDebugMode) {
                  debugPrint(
                    "Token refreshed successfully, retrying ${_queue.length} queued requests...",
                  );
                }

                // Retry all queued requests
                for (var item in _queue) {
                  _retryRequest(
                    item.requestOptions,
                    newAccessToken,
                  ).then(item.completer.complete).catchError((e) {
                    if (kDebugMode) {
                      debugPrint("Failed to retry queued request: $e");
                    }
                    item.completer.completeError(e);
                  });
                }
                _queue.clear();

                // Retry the current request
                final retryResponse = await _retryRequest(
                  requestOptions,
                  newAccessToken,
                );
                return handler.resolve(retryResponse);
              } else {
                // No access token in response
                if (kDebugMode) {
                  debugPrint(
                    "No access token in refresh response, logging out...",
                  );
                }
                await _logoutAndNavigateToLogin();
                return handler.next(error);
              }
            } on DioException catch (e) {
              // Refresh token request failed
              if (kDebugMode) {
                debugPrint("Refresh token request failed: ${e.message}");
              }

              // Complete all queued requests with error
              for (var item in _queue) {
                item.completer.completeError(e);
              }
              _queue.clear();

              await _logoutAndNavigateToLogin();
              return handler.next(error);
            } catch (e) {
              // Unexpected error during refresh
              if (kDebugMode) {
                debugPrint("Unexpected error during token refresh: $e");
              }

              // Complete all queued requests with error
              for (var item in _queue) {
                item.completer.completeError(error);
              }
              _queue.clear();

              await _logoutAndNavigateToLogin();
              return handler.next(error);
            } finally {
              _isRefreshing = false;
            }
          }
          handler.next(error);
        },
      ),
    ]);
  }

  static Future<LoginResponseModel> _refreshToken(String refreshToken) async {
    // Create a fresh Dio instance without interceptors to avoid infinite loop
    final dioInstance = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    final apiService = ApiService(
      dioInstance,
      // Use the same base URL as the rest of the API calls to avoid 404s
      baseUrl: ApiConstants.apiBaseUrl,
    );

    try {
      final response = await apiService.refreshToken(
        RefreshTokenRequestBody(refreshToken: refreshToken),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String newAccessToken,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: Map<String, dynamic>.from(requestOptions.headers)
        ..['Authorization'] = 'Bearer $newAccessToken',
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      sendTimeout: requestOptions.sendTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
      extra: requestOptions.extra,
      followRedirects: requestOptions.followRedirects,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      validateStatus: requestOptions.validateStatus,
    );

    return dio!.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }

  static Future<void> _logoutAndNavigateToLogin() async {
    // Clear all stored tokens
    await SharedPrefHelper.clearAllSecuredData();

    // Clear dio headers
    dio?.options.headers.remove('Authorization');

    // Reset refresh state
    _isRefreshing = false;
    _queue.clear();

    // Navigate to login screen and clear all routes
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routers.loginScreen,
      (route) => false,
    );
  }

  /// Clear the dio instance (useful for logout)
  static void clearDio() {
    dio?.interceptors.clear();
    dio = null;
    _isRefreshing = false;
    _queue.clear();
  }
}

/// Queue item class for pending requests during token refresh
class QueueItem {
  final RequestOptions requestOptions;
  final Completer<Response> completer;

  QueueItem(this.requestOptions, this.completer);
}
