import 'package:gym_management_app/core/api/api_error_handler.dart';
import 'package:gym_management_app/core/api/api_result.dart';
import 'package:gym_management_app/core/api/api_service.dart';
import 'package:gym_management_app/feature/login/data/model/login_request_body.dart';
import 'package:gym_management_app/feature/login/data/model/login_response_model.dart';

class LoginRepo {
  final ApiService _apiService;
  LoginRepo(this._apiService);
  Future<ApiResult<LoginResponseModel>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final response = await _apiService.login(loginRequestBody);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  // Future<Either<ApiErrorModel, LoginResponseModel>> login(
  //   LoginRequestBody loginRequestBody,
  // ) async {
  //   try {
  //     final response = await _apiService.login(loginRequestBody);
  //     return Right(response);
  //   } catch (error) {
  //     return Left(ErrorHandler.handle(error).apiErrorModel);
  //   }
  // }
}
/**

 import 'package:dartz/dartz.dart';
import 'package:gym_management_app/core/api/api_service.dart';
import 'package:gym_management_app/core/network/error_handler.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<Either<Failure, LoginResponse>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final response = await _apiService.login(loginRequestBody);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
} 
 */