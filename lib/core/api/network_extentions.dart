import 'package:easy_localization/easy_localization.dart';
import 'package:gym_management_app/core/api/api_error_model.dart';
import 'package:gym_management_app/core/api/date_source_enum.dart';
import 'package:gym_management_app/core/api/response_code.dart';

extension DataSourceExtension on DataSource {
  ApiErrorModel getFailure() {
    switch (this) {
      case DataSource.NO_CONTENT:
        return ApiErrorModel(
          code: ResponseCode.NO_CONTENT,
          message: 'dio_errors.bad_response'.tr(),
        );
      case DataSource.BAD_REQUEST:
        return ApiErrorModel(
          code: ResponseCode.BAD_REQUEST,
          message: 'dio_errors.400'.tr(),
        );
      case DataSource.FORBIDDEN:
        return ApiErrorModel(
          code: ResponseCode.FORBIDDEN,
          message: 'dio_errors.403'.tr(),
        );
      case DataSource.UNAUTORISED:
        return ApiErrorModel(
          code: ResponseCode.UNAUTORISED,
          message: 'dio_errors.401'.tr(),
        );
      case DataSource.NOT_FOUND:
        return ApiErrorModel(
          code: ResponseCode.NOT_FOUND,
          message: 'dio_errors.404'.tr(),
        );
      case DataSource.INTERNAL_SERVER_ERROR:
        return ApiErrorModel(
          code: ResponseCode.INTERNAL_SERVER_ERROR,
          message: 'dio_errors.500'.tr(),
        );
      case DataSource.CONNECT_TIMEOUT:
        return ApiErrorModel(
          code: ResponseCode.CONNECT_TIMEOUT,
          message: 'dio_errors.connection_timeout'.tr(),
        );
      case DataSource.CANCEL:
        return ApiErrorModel(
          code: ResponseCode.CANCEL,
          message: 'dio_errors.cancel'.tr(),
        );
      case DataSource.RECIEVE_TIMEOUT:
        return ApiErrorModel(
          code: ResponseCode.RECIEVE_TIMEOUT,
          message: 'dio_errors.receive_timeout'.tr(),
        );
      case DataSource.SEND_TIMEOUT:
        return ApiErrorModel(
          code: ResponseCode.SEND_TIMEOUT,
          message: 'dio_errors.send_timeout'.tr(),
        );
      case DataSource.CACHE_ERROR:
        return ApiErrorModel(
          code: ResponseCode.CACHE_ERROR,
          message: 'dio_errors.default_error'.tr(),
        );
      case DataSource.NO_INTERNET_CONNECTION:
        return ApiErrorModel(
          code: ResponseCode.NO_INTERNET_CONNECTION,
          message: 'dio_errors.no_internet'.tr(),
        );
      case DataSource.DEFAULT:
        return ApiErrorModel(
          code: ResponseCode.DEFAULT,
          message: 'dio_errors.default_error'.tr(),
        );
    }
  }
}
