import 'package:gym_management_app/core/api/api_error_handler.dart';
import 'package:gym_management_app/core/api/api_error_model.dart';
import 'package:gym_management_app/core/api/api_service.dart';
import 'package:gym_management_app/core/shard_models.dart/pagenation_model.dart';
import 'package:gym_management_app/core/shard_models.dart/pagination_filter_model.dart';
import 'package:gym_management_app/feature/attendance/data/model/attendance_record_model.dart';
import 'package:gym_management_app/feature/attendance/data/model/attendance_request_body.dart';
import 'package:gym_management_app/feature/attendance/data/model/current_attendance_model.dart';
import 'package:gym_management_app/feature/attendance/data/model/monthly_statistics_model.dart';
import 'package:dartz/dartz.dart';

class AttendanceRepo {
  final ApiService _apiService;

  AttendanceRepo(this._apiService);

  Future<Either<ApiErrorModel, ApiErrorModel>> checkIn(
    AttendanceRequestBody attendanceRequestBody,
  ) async {
    try {
      final response = await _apiService.checkIn(attendanceRequestBody);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ApiErrorModel, ApiErrorModel>> checkOut(
    AttendanceRequestBody attendanceRequestBody,
  ) async {
    try {
      final response = await _apiService.checkOut(attendanceRequestBody);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ApiErrorModel, CurrentAttendanceModel>>
  getCurrentAttendance() async {
    try {
      final response = await _apiService.getCurrentAttendance();
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ApiErrorModel, MonthlyStatisticsModel>>
  getMonthlyStatistics() async {
    try {
      final response = await _apiService.getMonthlyStatistics();
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ApiErrorModel, AppPageListModel<AttendanceRecordModel>>>
  getAttendanceRecords(
    MyAttendanceDateFilterModel attendanceDateFilterModel,
  ) async {
    try {
      final response = await _apiService.getAttendanceRecords(
        attendanceDateFilterModel,
      );
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
