import 'package:equatable/equatable.dart';

abstract class AttendanceRecordsState extends Equatable {
  const AttendanceRecordsState();

  @override
  List<Object?> get props => [];
}

class AttendanceRecordsInitial extends AttendanceRecordsState {}
