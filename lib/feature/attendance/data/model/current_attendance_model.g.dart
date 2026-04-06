// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentAttendanceModel _$CurrentAttendanceModelFromJson(
  Map<String, dynamic> json,
) => CurrentAttendanceModel(
  clockInWork: json['clockInWork'] as bool?,
  clockOutWork: json['clockOutWork'] as bool?,
  clockIn: json['clockIn'] != null
      ? DateTimeHelper().timeOfFromString(json['clockIn'])
      : json['clockIn'],
  clockOut: json['clockOut'] != null
      ? DateTimeHelper().timeOfFromString(json['clockOut'])
      : json['clockOut'],
  stateValue: json['stateValue'] as String?,
  shiftData: json['shiftData'] as String?,
);

Map<String, dynamic> _$CurrentAttendanceModelToJson(
  CurrentAttendanceModel instance,
) => <String, dynamic>{
  'clockInWork': instance.clockInWork,
  'clockOutWork': instance.clockOutWork,
  'clockIn': instance.clockIn,
  'clockOut': instance.clockOut,
  'stateValue': instance.stateValue,
  'shiftData': instance.shiftData,
};
