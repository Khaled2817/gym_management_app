// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRequestBody _$AttendanceRequestBodyFromJson(
  Map<String, dynamic> json,
) => AttendanceRequestBody(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$AttendanceRequestBodyToJson(
  AttendanceRequestBody instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'note': instance.note,
};
