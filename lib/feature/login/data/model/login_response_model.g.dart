// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(
  Map<String, dynamic> json,
) => LoginResponseModel(
  isError: json['isError'] as bool,
  message: json['message'] as String?,
  targetId: (json['targetId'] as num?)?.toInt(),
  returnedValue: (json['returnedValue'] as num?)?.toInt(),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  details: json['details'] as String?,
  token: json['token'] as String?,
  route: json['route'] as String?,
  userId: (json['userId'] as num?)?.toInt(),
  userName: json['userName'] as String?,
  name: json['name'] as String?,
  userType: json['userType'] as String?,
  roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
  companyBranches: (json['companyBranches'] as List<dynamic>?)
      ?.map((e) => CompanyBranchModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  refreshToken: json['refreshToken'] as String?,
  tokenExpiration: json['tokenExpiration'] == null
      ? null
      : DateTime.parse(json['tokenExpiration'] as String),
  refreshTokenExpiration: json['refreshTokenExpiration'] == null
      ? null
      : DateTime.parse(json['refreshTokenExpiration'] as String),
  mainCompanyBranch: json['mainCompanyBranch'] == null
      ? null
      : CompanyBranchModel.fromJson(
          json['mainCompanyBranch'] as Map<String, dynamic>,
        ),
  employeeId: (json['employeeId'] as num?)?.toInt(),
);

Map<String, dynamic> _$LoginResponseModelToJson(
  LoginResponseModel instance,
) => <String, dynamic>{
  'isError': instance.isError,
  'message': instance.message,
  'targetId': instance.targetId,
  'returnedValue': instance.returnedValue,
  'errors': instance.errors,
  'details': instance.details,
  'token': instance.token,
  'route': instance.route,
  'userId': instance.userId,
  'userName': instance.userName,
  'name': instance.name,
  'userType': instance.userType,
  'roles': instance.roles,
  'companyBranches': instance.companyBranches,
  'refreshToken': instance.refreshToken,
  'tokenExpiration': instance.tokenExpiration?.toIso8601String(),
  'refreshTokenExpiration': instance.refreshTokenExpiration?.toIso8601String(),
  'mainCompanyBranch': instance.mainCompanyBranch,
  'employeeId': instance.employeeId,
};

CompanyBranchModel _$CompanyBranchModelFromJson(Map<String, dynamic> json) =>
    CompanyBranchModel(
      id: json['id'] as String?,
      logo: json['logo'] as String?,
      name: json['name'] as String?,
      nameLocalized: json['nameLocalized'] as String?,
    );

Map<String, dynamic> _$CompanyBranchModelToJson(CompanyBranchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo': instance.logo,
      'name': instance.name,
      'nameLocalized': instance.nameLocalized,
    };
