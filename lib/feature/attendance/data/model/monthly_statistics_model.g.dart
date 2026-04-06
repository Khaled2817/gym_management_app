// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyStatisticsModel _$MonthlyStatisticsModelFromJson(
  Map<String, dynamic> json,
) => MonthlyStatisticsModel(
  attendanceDays: (json['attendanceDays'] as num?)?.toInt(),
  attendanceDaysWithLate: (json['attendanceDaysWithLate'] as num?)?.toInt(),
  attendanceDaysWithEarlyDeparture:
      (json['attendanceDaysWithEarlyDeparture'] as num?)?.toInt(),
  attendanceDaysWithEarlyDepartureAndLate:
      (json['attendanceDaysWithEarlyDepartureAndLate'] as num?)?.toInt(),
  absentDays: (json['absentDays'] as num?)?.toInt(),
  holidays: (json['holidays'] as num?)?.toInt(),
);

Map<String, dynamic> _$MonthlyStatisticsModelToJson(
  MonthlyStatisticsModel instance,
) => <String, dynamic>{
  'attendanceDays': instance.attendanceDays,
  'attendanceDaysWithLate': instance.attendanceDaysWithLate,
  'attendanceDaysWithEarlyDeparture': instance.attendanceDaysWithEarlyDeparture,
  'attendanceDaysWithEarlyDepartureAndLate':
      instance.attendanceDaysWithEarlyDepartureAndLate,
  'absentDays': instance.absentDays,
  'holidays': instance.holidays,
};
