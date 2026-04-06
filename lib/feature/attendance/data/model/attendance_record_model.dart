import 'package:json_annotation/json_annotation.dart';

part 'attendance_record_model.g.dart';

@JsonSerializable()
class AttendanceRecordModel {
  final int? employeeId;
  final String? employeeName;
  final DateTime? transactionDate;
  final String? note;
  final double? latitude;
  final double? longitude;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final String? workHours;
  final String? clockInNote;
  final String? clockOutNote;
  final String? shiftName;
  final int? earlyDepartureTotalMinutes;
  final int? lateDurationTotalMinutes;
  final int? excessiveDelayMinutes;
  final int? excessiveEarlyDepartureMinutes;
  final int? totalOvertimeMinutes;
  final int? attendanceMainState;
  final int? attendanceState;
  final double? clockInLatitude;
  final double? clockInLongitude;
  final double? clockOutLatitude;
  final double? clockOutLongitude;
  final String? attendanceStateValue;

  AttendanceRecordModel({
    this.employeeId,
    this.employeeName,
    this.transactionDate,
    this.note,
    this.latitude,
    this.longitude,
    this.clockIn,
    this.clockOut,
    this.workHours,
    this.clockInNote,
    this.clockOutNote,
    this.shiftName,
    this.earlyDepartureTotalMinutes,
    this.lateDurationTotalMinutes,
    this.excessiveDelayMinutes,
    this.excessiveEarlyDepartureMinutes,
    this.totalOvertimeMinutes,
    this.attendanceMainState,
    this.attendanceState,
    this.clockInLatitude,
    this.clockInLongitude,
    this.clockOutLatitude,
    this.clockOutLongitude,
    this.attendanceStateValue,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);

  static List<AttendanceRecordModel> fromJsonList(dynamic myList) {
    final List<AttendanceRecordModel> data = [];
    for (final json in (myList as List)) {
      data.add(AttendanceRecordModel.fromJson(json));
    }
    return data;
  }
}
