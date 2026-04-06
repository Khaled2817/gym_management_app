import 'dart:convert';
import 'package:gym_management_app/core/storage/shared_pref_helper.dart';
import 'package:gym_management_app/core/storage/shared_pref_keys.dart';
import 'package:gym_management_app/feature/login/data/model/login_response_model.dart';

class TokenStorage {
  // Save login response data
  static Future<void> saveLoginData(LoginResponseModel loginResponse) async {
    // Save token securely
    if (loginResponse.token != null) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userToken,
        loginResponse.token!,
      );
    }

    // Save refresh token securely
    if (loginResponse.refreshToken != null) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.refreshToken,
        loginResponse.refreshToken!,
      );
    }

    // Save other user data
    if (loginResponse.userId != null) {
      await SharedPrefHelper.setData(
        SharedPrefKeys.userId,
        loginResponse.userId,
      );
    }

    if (loginResponse.userName != null) {
      await SharedPrefHelper.setData(
        SharedPrefKeys.userName,
        loginResponse.userName,
      );
    }

    if (loginResponse.name != null) {
      await SharedPrefHelper.setData(SharedPrefKeys.name, loginResponse.name);
    }

    if (loginResponse.userType != null) {
      await SharedPrefHelper.setData(
        SharedPrefKeys.userType,
        loginResponse.userType,
      );
    }

    if (loginResponse.route != null) {
      await SharedPrefHelper.setData(SharedPrefKeys.route, loginResponse.route);
    }

    if (loginResponse.roles != null) {
      await SharedPrefHelper.setData(
        SharedPrefKeys.roles,
        jsonEncode(loginResponse.roles),
      );
    }

    if (loginResponse.tokenExpiration != null) {
      await SharedPrefHelper.setData(
        SharedPrefKeys.tokenExpiration,
        loginResponse.tokenExpiration!.toIso8601String(),
      );
    }

    if (loginResponse.refreshTokenExpiration != null) {
      await SharedPrefHelper.setData(
        SharedPrefKeys.refreshTokenExpiration,
        loginResponse.refreshTokenExpiration!.toIso8601String(),
      );
    }
  }

  // Get token
  static Future<String> getToken() async {
    return await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  }

  // Get refresh token
  static Future<String> getRefreshToken() async {
    return await SharedPrefHelper.getSecuredString(SharedPrefKeys.refreshToken);
  }

  // Get user ID
  static Future<int> getUserId() async {
    return await SharedPrefHelper.getInt(SharedPrefKeys.userId);
  }

  // Get user name
  static Future<String> getUserName() async {
    return await SharedPrefHelper.getString(SharedPrefKeys.userName);
  }

  // Get name
  static Future<String> getName() async {
    return await SharedPrefHelper.getString(SharedPrefKeys.name);
  }

  // Get user type
  static Future<String> getUserType() async {
    return await SharedPrefHelper.getString(SharedPrefKeys.userType);
  }

  // Get route
  static Future<String> getRoute() async {
    return await SharedPrefHelper.getString(SharedPrefKeys.route);
  }

  // Get roles
  static Future<List<String>> getRoles() async {
    final rolesString = await SharedPrefHelper.getString(SharedPrefKeys.roles);
    if (rolesString.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(rolesString);
    return decoded.cast<String>();
  }

  // Get token expiration
  static Future<DateTime?> getTokenExpiration() async {
    final expirationString = await SharedPrefHelper.getString(
      SharedPrefKeys.tokenExpiration,
    );
    if (expirationString.isEmpty) return null;
    return DateTime.parse(expirationString);
  }

  // Get refresh token expiration
  static Future<DateTime?> getRefreshTokenExpiration() async {
    final expirationString = await SharedPrefHelper.getString(
      SharedPrefKeys.refreshTokenExpiration,
    );
    if (expirationString.isEmpty) return null;
    return DateTime.parse(expirationString);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token.isNotEmpty;
  }

  // Check if token is expired
  static Future<bool> isTokenExpired() async {
    final expiration = await getTokenExpiration();
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }

  // Clear all login data
  static Future<void> clearLoginData() async {
    await SharedPrefHelper.removeData(SharedPrefKeys.userToken);
    await SharedPrefHelper.removeData(SharedPrefKeys.refreshToken);
    await SharedPrefHelper.removeData(SharedPrefKeys.userId);
    await SharedPrefHelper.removeData(SharedPrefKeys.userName);
    await SharedPrefHelper.removeData(SharedPrefKeys.name);
    await SharedPrefHelper.removeData(SharedPrefKeys.userType);
    await SharedPrefHelper.removeData(SharedPrefKeys.route);
    await SharedPrefHelper.removeData(SharedPrefKeys.roles);
    await SharedPrefHelper.removeData(SharedPrefKeys.tokenExpiration);
    await SharedPrefHelper.removeData(SharedPrefKeys.refreshTokenExpiration);
    await SharedPrefHelper.clearAllSecuredData();
  }
}
