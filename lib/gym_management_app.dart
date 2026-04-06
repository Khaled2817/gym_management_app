import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/helpers/app_navigator.dart';
import 'package:gym_management_app/core/routing/app_router.dart';
import 'package:gym_management_app/core/routing/routers.dart';
import 'package:gym_management_app/core/theming/app_themes.dart';
import 'package:gym_management_app/feature/settings/logic/cubit/theme_cubit.dart';
import 'package:gym_management_app/feature/settings/logic/cubit/theme_states.dart';

class GymManagementApp extends StatelessWidget {
  final AppRouter appRouter;
  const GymManagementApp({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocBuilder<ThemeCubit, ThemeStates>(
        builder: (context, state) {
          // تحديث شريط الحالة بناءً على الثيم
          final isDark = state.isDarkMode;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            ),
          );

          return MaterialApp(
            title: 'H Assistant',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            navigatorKey: navigatorKey,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: appRouter.onGenerateRoute,
            initialRoute: Routers.splashScreen,
          );
        },
      ),
    );
  }
}
