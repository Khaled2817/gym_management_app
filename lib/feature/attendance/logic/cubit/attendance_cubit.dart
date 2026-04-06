import 'package:bloc/bloc.dart';
import 'package:gym_management_app/core/helpers/location_helper.dart';
import 'package:gym_management_app/feature/attendance/data/model/attendance_request_body.dart';
import 'package:gym_management_app/feature/attendance/data/model/current_attendance_model.dart';
import 'package:gym_management_app/feature/attendance/data/repo/attendance_repo.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_states.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AttendanceCubit extends Cubit<AttendanceStates> {
  final AttendanceRepo _attendanceRepo;

  AttendanceCubit(this._attendanceRepo) : super(AttendanceInitial());

  final FormGroup form = FormGroup({'note': FormControl<String>()});
  String? get note => form.control('note').value;

  CurrentAttendanceModel? currentAttendance;

  Future<void> checkIn() async {
    emit(AttendanceLocationLoading());

    final locationResult = await LocationHelper.validateLocation();
    if (!locationResult.isValid) {
      emit(
        AttendanceError(
          error: locationResult.error ?? 'فشل في الحصول على الموقع',
        ),
      );
      return;
    }

    emit(AttendanceLoading());

    final position = locationResult.position!;
    final result = await _attendanceRepo.checkIn(
      AttendanceRequestBody(
        latitude: position.latitude,
        longitude: position.longitude,
        note: note,
      ),
    );

    result.fold(
      (error) =>
          emit(AttendanceError(error: error.message ?? 'فشل في تسجيل الحضور')),
      (success) {
        emit(
          AttendanceSuccess(
            message: success.message ?? 'تم تسجيل الحضور بنجاح',
          ),
        );
        // getCurrentAttendance();
      },
    );
  }

  Future<void> checkOut() async {
    emit(AttendanceLocationLoading());

    final locationResult = await LocationHelper.validateLocation();
    if (!locationResult.isValid) {
      emit(
        AttendanceError(
          error: locationResult.error ?? 'فشل في الحصول على الموقع',
        ),
      );
      return;
    }

    emit(AttendanceLoading());

    final position = locationResult.position!;
    final result = await _attendanceRepo.checkOut(
      AttendanceRequestBody(
        latitude: position.latitude,
        longitude: position.longitude,
        note: note,
      ),
    );

    result.fold(
      (error) => emit(
        AttendanceError(error: error.message ?? 'فشل في تسجيل الانصراف'),
      ),
      (success) {
        emit(
          AttendanceSuccess(
            message: success.message ?? 'تم تسجيل الانصراف بنجاح',
          ),
        );

        // getCurrentAttendance();
      },
    );
  }

  void reset() {
    form.control('note').value = null;
    emit(AttendanceInitial());
  }

  Future<void> getCurrentAttendance() async {
    emit(AttendanceLoading());

    final result = await _attendanceRepo.getCurrentAttendance();

    result.fold(
      (error) => emit(
        AttendanceError(error: error.message ?? 'فشل في تحميل البيانات'),
      ),
      (attendance) {
        currentAttendance = attendance;
        emit(AttendanceCurrentLoaded(attendance: attendance));
      },
    );
  }
}
