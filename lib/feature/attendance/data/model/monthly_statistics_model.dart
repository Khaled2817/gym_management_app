import 'package:json_annotation/json_annotation.dart';

part 'monthly_statistics_model.g.dart';

@JsonSerializable()
class MonthlyStatisticsModel {
  final int? attendanceDays;
  final int? attendanceDaysWithLate;
  final int? attendanceDaysWithEarlyDeparture;
  final int? attendanceDaysWithEarlyDepartureAndLate;
  final int? absentDays;
  final int? holidays;
  MonthlyStatisticsModel({
    this.attendanceDays,
    this.attendanceDaysWithLate,
    this.attendanceDaysWithEarlyDeparture,
    this.attendanceDaysWithEarlyDepartureAndLate,
    this.absentDays,
    this.holidays,
  });
  factory MonthlyStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatisticsModelFromJson(json);
}
