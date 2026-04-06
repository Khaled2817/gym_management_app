import 'package:json_annotation/json_annotation.dart';

part 'attendance_request_body.g.dart';

@JsonSerializable()
class AttendanceRequestBody {
  final double latitude;
  final double longitude;
  final String? note;

  AttendanceRequestBody({
    required this.latitude,
    required this.longitude,
    this.note,
  });

  Map<String, dynamic> toJson() => _$AttendanceRequestBodyToJson(this);
}
