import 'package:gym_management_app/feature/attendance/data/model/monthly_statistics_model.dart';

abstract class StatisticsStates {}

class StatisticsInitial extends StatisticsStates {}

class StatisticsLoading extends StatisticsStates {}

class StatisticsLoaded extends StatisticsStates {
  final MonthlyStatisticsModel statistics;
  StatisticsLoaded({required this.statistics});
}

class StatisticsError extends StatisticsStates {
  final String error;
  StatisticsError({required this.error});
}
