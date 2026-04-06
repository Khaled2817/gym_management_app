import 'package:json_annotation/json_annotation.dart';
part 'login_request_body.g.dart';
@JsonSerializable()
class LoginRequestBody {
  final String userName;
  final String password;
  final String deviceToken;
  final String deviceId;
  final bool rememberMe;
  LoginRequestBody({
    required this.userName,
    required this.password,
    required this.deviceToken,
    required this.deviceId,
    required this.rememberMe,
  });
  Map<String, dynamic> toJson() => _$LoginRequestBodyToJson(this);
}