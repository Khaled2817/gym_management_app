import 'package:dio/dio.dart';
import 'package:gym_management_app/core/api/date_source_enum.dart';
import 'package:gym_management_app/core/api/network_extentions.dart';
import 'api_error_model.dart';

class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      apiErrorModel = _handleError(error);
    } else {
      // default error
      apiErrorModel = DataSource.DEFAULT.getFailure();
    }
  }
}

class ErrorHandlerDartz {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      return _handleError(error);
    } else {
      return DataSource.DEFAULT.getFailure();
    }
  }
}

ApiErrorModel _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badResponse:
      if (error.response?.data != null) {
        return ApiErrorModel.fromJson(error.response!.data);
      } else {
        return DataSource.DEFAULT.getFailure();
      }
    case DioExceptionType.unknown:
      // Check if there's response data
      if (error.response?.data != null) {
        return ApiErrorModel.fromJson(error.response!.data);
      }
      // Check for network/connection errors
      if (error.error.toString().contains('SocketException') ||
          error.error.toString().contains('Connection refused') ||
          error.error.toString().contains('Network is unreachable')) {
        return DataSource.NO_INTERNET_CONNECTION.getFailure();
      }
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.NO_INTERNET_CONNECTION.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.DEFAULT.getFailure();
  }
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
