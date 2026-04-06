import 'package:gym_management_app/core/api/api_error_model.dart';
import 'package:gym_management_app/core/shard_models.dart/pagenation_model.dart';
import 'package:gym_management_app/core/shard_models.dart/pagination_filter_model.dart';
import 'package:dio/dio.dart';
import 'package:gym_management_app/core/api/refresh_token_model.dart';
import 'package:gym_management_app/feature/login/data/model/login_request_body.dart';
import 'package:gym_management_app/feature/login/data/model/login_response_model.dart';
import 'package:gym_management_app/feature/attendance/data/model/attendance_request_body.dart';
import 'package:gym_management_app/feature/attendance/data/model/attendance_record_model.dart';
import 'package:gym_management_app/feature/attendance/data/model/current_attendance_model.dart';
import 'package:gym_management_app/feature/attendance/data/model/monthly_statistics_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:gym_management_app/core/api/api_constants.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponseModel> login(@Body() LoginRequestBody loginRequestBody);

  @POST(ApiConstants.refreshToken)
  Future<LoginResponseModel> refreshToken(
    @Body() RefreshTokenRequestBody refreshTokenRequestBody,
  );

  @POST(ApiConstants.checkIn)
  Future<ApiErrorModel> checkIn(@Body() AttendanceRequestBody body);

  @POST(ApiConstants.checkOut)
  Future<ApiErrorModel> checkOut(@Body() AttendanceRequestBody body);

  @GET(ApiConstants.todayAttendance)
  Future<CurrentAttendanceModel> getCurrentAttendance();

  @GET(ApiConstants.getCurrentEmployeeMonthlyAttendanceStatic)
  Future<MonthlyStatisticsModel> getMonthlyStatistics();

  @POST(ApiConstants.getAttendanceRecords)
  Future<AppPageListModel<AttendanceRecordModel>> getAttendanceRecords(
    @Body() MyAttendanceDateFilterModel attendanceDateFilterModel,
  );
}
