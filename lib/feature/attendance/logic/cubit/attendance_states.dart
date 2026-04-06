import 'package:gym_management_app/feature/attendance/data/model/current_attendance_model.dart';

abstract class AttendanceStates {}

class AttendanceInitial extends AttendanceStates {}

class AttendanceLoading extends AttendanceStates {}

class AttendanceLocationLoading extends AttendanceStates {}

class AttendanceSuccess extends AttendanceStates {
  final String message;
  AttendanceSuccess({required this.message});
}

class AttendanceError extends AttendanceStates {
  final String error;
  AttendanceError({required this.error});
}

class AttendanceCurrentLoaded extends AttendanceStates {
  final CurrentAttendanceModel attendance;
  AttendanceCurrentLoaded({required this.attendance});
}
