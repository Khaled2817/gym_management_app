import 'package:json_annotation/json_annotation.dart';
part 'refresh_token_model.g.dart';
@JsonSerializable()
class RefreshTokenRequestBody {
final String refreshToken;
RefreshTokenRequestBody({required this.refreshToken}); 
Map<String, dynamic> toJson() => _$RefreshTokenRequestBodyToJson(this);
}