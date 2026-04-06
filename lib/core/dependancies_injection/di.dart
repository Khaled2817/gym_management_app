import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_records_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gym_management_app/core/api/api_service.dart';
import 'package:gym_management_app/core/api/dio_factory.dart';
import 'package:gym_management_app/feature/login/data/repo/login_repo.dart';
import 'package:gym_management_app/feature/login/logic/cubit/login_cubit.dart';
import 'package:gym_management_app/feature/settings/logic/cubit/theme_cubit.dart';
import 'package:gym_management_app/feature/attendance/data/repo/attendance_repo.dart';

final getIt = GetIt.instance;
Future<void> dependancyInjection() async {
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerFactory<AttendanceRepo>(() => AttendanceRepo(getIt()));
  getIt.registerFactory<AttendanceRecordsCubit>(
    () => AttendanceRecordsCubit(getIt()),
  );
}
