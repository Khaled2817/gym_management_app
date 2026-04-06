import 'package:gym_management_app/core/helpers/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_attendance_model.g.dart';

@JsonSerializable()
class CurrentAttendanceModel {
  final bool? clockInWork;
  final bool? clockOutWork;
  final TimeOfDay? clockIn;
  final TimeOfDay? clockOut;
  final String? stateValue;
  final String? shiftData;

  CurrentAttendanceModel({
    this.clockInWork,
    this.clockOutWork,
    this.clockIn,
    this.clockOut,
    this.stateValue,
    this.shiftData,
  });

  factory CurrentAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentAttendanceModelFromJson(json);
}
