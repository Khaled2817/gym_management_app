import 'package:bloc/bloc.dart';
import 'package:gym_management_app/core/api/token_storage.dart';
import 'package:gym_management_app/core/shard_models.dart/pagenation_model.dart';
import 'package:gym_management_app/core/shard_models.dart/pagination_filter_model.dart';
import 'package:gym_management_app/feature/attendance/data/repo/attendance_repo.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_records_state.dart';

class AttendanceRecordsCubit extends Cubit<AttendanceRecordsState> {
  final AttendanceRepo _attendanceRepo;

  AttendanceRecordsCubit(this._attendanceRepo)
    : super(AttendanceRecordsInitial());

  MyAttendanceDateFilterModel filter = MyAttendanceDateFilterModel();

  Future<void> initEmployeeId() async {
    final userId = await TokenStorage.getUserId();
    filter.employeeId = userId;
    filter.hasNext = true;
  }

  Future<AppPageListModel> getAttendanceRecords(
    MyAttendanceDateFilterModel filter,
  ) async {
    final result = await _attendanceRepo.getAttendanceRecords(filter);
    return result.fold((error) => AppPageListModel([]), (pageList) => pageList);
  }

  void setFilterDate(DateTime? startDate, DateTime? endDate) {
    filter.startDate = startDate;
    filter.endDate = endDate;
    filter.page = 0;
    filter.hasNext = true;
  }

  void resetFilter() {
    filter.startDate = null;
    filter.endDate = null;
    filter.page = 0;
    filter.hasNext = true;
  }
}
