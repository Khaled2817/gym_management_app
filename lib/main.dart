import 'package:gym_management_app/core/notifications/attendance_notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/routing/app_router.dart';
import 'package:gym_management_app/gym_management_app.dart';
import 'package:gym_management_app/core/dependancies_injection/di.dart';
import 'package:gym_management_app/core/shard_models.dart/my_bloc_observer.dart';
import 'package:gym_management_app/feature/settings/logic/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await AttendanceNotificationService.instance.init();
  // await FirebaseMessagingService.instance.init();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  dependancyInjection();
  Bloc.observer = MyBlocObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    EasyLocalization(
      startLocale: const Locale('ar'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      child: BlocProvider(
        create: (context) => getIt<ThemeCubit>(),
        child: CheckInApp(appRouter: AppRouter()),
      ),
    ),
  );
}
//marge