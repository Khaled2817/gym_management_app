import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final bool isError;
  final String? message;
  final int? targetId;
  final int? returnedValue;
  final List<String>? errors;
  final String? details;
  final String? token;
  final String? route;
  final int? userId;
  final String? userName;
  final String? name;
  final String? userType;
  final List<String>? roles;
  final List<CompanyBranchModel>? companyBranches;
  final String? refreshToken;
  final DateTime? tokenExpiration;
  final DateTime? refreshTokenExpiration;
  final CompanyBranchModel? mainCompanyBranch;
  final int? employeeId;

  LoginResponseModel({
    required this.isError,
    this.message,
    this.targetId,
    this.returnedValue,
    this.errors,
    this.details,
    this.token,
    this.route,
    this.userId,
    this.userName,
    this.name,
    this.userType,
    this.roles,
    this.companyBranches,
    this.refreshToken,
    this.tokenExpiration,
    this.refreshTokenExpiration,
    this.mainCompanyBranch,
    this.employeeId,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}

@JsonSerializable()
class CompanyBranchModel {
  final String? id;
  final String? logo;
  final String? name;
  final String? nameLocalized;

  CompanyBranchModel({this.id, this.logo, this.name, this.nameLocalized});

  factory CompanyBranchModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyBranchModelFromJson(json);
}
