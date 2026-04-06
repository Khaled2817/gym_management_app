// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecordModel _$AttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => AttendanceRecordModel(
  employeeId: (json['employeeId'] as num?)?.toInt(),
  employeeName: json['employeeName'] as String?,
  transactionDate: json['transactionDate'] == null
      ? null
      : DateTime.parse(json['transactionDate'] as String),
  note: json['note'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  clockIn: json['clockIn'] == null
      ? null
      : DateTime.parse(json['clockIn'] as String),
  clockOut: json['clockOut'] == null
      ? null
      : DateTime.parse(json['clockOut'] as String),
  workHours: json['workHours'] as String?,
  clockInNote: json['clockInNote'] as String?,
  clockOutNote: json['clockOutNote'] as String?,
  shiftName: json['shiftName'] as String?,
  earlyDepartureTotalMinutes: (json['earlyDepartureTotalMinutes'] as num?)
      ?.toInt(),
  lateDurationTotalMinutes: (json['lateDurationTotalMinutes'] as num?)?.toInt(),
  excessiveDelayMinutes: (json['excessiveDelayMinutes'] as num?)?.toInt(),
  excessiveEarlyDepartureMinutes:
      (json['excessiveEarlyDepartureMinutes'] as num?)?.toInt(),
  totalOvertimeMinutes: (json['totalOvertimeMinutes'] as num?)?.toInt(),
  attendanceMainState: (json['attendanceMainState'] as num?)?.toInt(),
  attendanceState: (json['attendanceState'] as num?)?.toInt(),
  clockInLatitude: (json['clockInLatitude'] as num?)?.toDouble(),
  clockInLongitude: (json['clockInLongitude'] as num?)?.toDouble(),
  clockOutLatitude: (json['clockOutLatitude'] as num?)?.toDouble(),
  clockOutLongitude: (json['clockOutLongitude'] as num?)?.toDouble(),
  attendanceStateValue: json['attendanceStateValue'] as String?,
);

Map<String, dynamic> _$AttendanceRecordModelToJson(
  AttendanceRecordModel instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'employeeName': instance.employeeName,
  'transactionDate': instance.transactionDate?.toIso8601String(),
  'note': instance.note,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'clockIn': instance.clockIn?.toIso8601String(),
  'clockOut': instance.clockOut?.toIso8601String(),
  'workHours': instance.workHours,
  'clockInNote': instance.clockInNote,
  'clockOutNote': instance.clockOutNote,
  'shiftName': instance.shiftName,
  'earlyDepartureTotalMinutes': instance.earlyDepartureTotalMinutes,
  'lateDurationTotalMinutes': instance.lateDurationTotalMinutes,
  'excessiveDelayMinutes': instance.excessiveDelayMinutes,
  'excessiveEarlyDepartureMinutes': instance.excessiveEarlyDepartureMinutes,
  'totalOvertimeMinutes': instance.totalOvertimeMinutes,
  'attendanceMainState': instance.attendanceMainState,
  'attendanceState': instance.attendanceState,
  'clockInLatitude': instance.clockInLatitude,
  'clockInLongitude': instance.clockInLongitude,
  'clockOutLatitude': instance.clockOutLatitude,
  'clockOutLongitude': instance.clockOutLongitude,
  'attendanceStateValue': instance.attendanceStateValue,
};
