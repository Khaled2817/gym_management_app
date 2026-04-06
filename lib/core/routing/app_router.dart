import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/dependancies_injection/di.dart';
import 'package:gym_management_app/core/routing/routers.dart';
import 'package:gym_management_app/core/splash/animated_splash_screen.dart';
import 'package:gym_management_app/core/widgets/main_home_widegt.dart';
import 'package:gym_management_app/feature/employees/ui/screen/employees_screen.dart';
import 'package:gym_management_app/feature/login/logic/cubit/login_cubit.dart';
import 'package:gym_management_app/feature/login/ui/screen/login_screen.dart';
import 'package:gym_management_app/feature/onboarding/ui/screen/onboarding_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routers.splashScreen:
        return MaterialPageRoute(builder: (_) => const AnimatedSplashScreen());
      case Routers.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routers.mainHome:
        return MaterialPageRoute(builder: (_) => const MainNavPage());
      case Routers.employeesScreen:
        return MaterialPageRoute(builder: (_) => const EmployeesScreen());
      case Routers.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
