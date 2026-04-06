import 'package:bloc/bloc.dart';
import 'package:gym_management_app/feature/attendance/data/repo/attendance_repo.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/statistics_states.dart';

class StatisticsCubit extends Cubit<StatisticsStates> {
  final AttendanceRepo _attendanceRepo;

  StatisticsCubit(this._attendanceRepo) : super(StatisticsInitial());

  Future<void> getMonthlyStatistics() async {
    emit(StatisticsLoading());

    final result = await _attendanceRepo.getMonthlyStatistics();

    result.fold(
      (error) => emit(
        StatisticsError(error: error.message ?? 'فشل في تحميل الإحصائيات'),
      ),
      (statistics) => emit(StatisticsLoaded(statistics: statistics)),
    );
  }
}
