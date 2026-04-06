// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestBody _$LoginRequestBodyFromJson(Map<String, dynamic> json) =>
    LoginRequestBody(
      userName: json['userName'] as String,
      password: json['password'] as String,
      deviceToken: json['deviceToken'] as String,
      deviceId: json['deviceId'] as String,
      rememberMe: json['rememberMe'] as bool,
    );

Map<String, dynamic> _$LoginRequestBodyToJson(LoginRequestBody instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'deviceToken': instance.deviceToken,
      'deviceId': instance.deviceId,
      'rememberMe': instance.rememberMe,
    };
