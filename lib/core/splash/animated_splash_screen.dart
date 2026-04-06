import 'package:gym_management_app/core/api/token_storage.dart';
import 'package:gym_management_app/core/helpers/asset_helper.dart';
import 'package:gym_management_app/core/helpers/extentions.dart';
import 'package:gym_management_app/core/routing/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Navigate after animation completes
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _navigateBasedOnToken();
      }
    });
  }

  Future<void> _navigateBasedOnToken() async {
    final isLoggedIn = await TokenStorage.isLoggedIn();
    if (!mounted) return;
    if (isLoggedIn) {
      context.pushReplacementNamed(Routers.mainHome);
    } else {
      context.pushReplacementNamed(Routers.loginScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(AssetHelper.logo, height: 200.h, width: 200.w),
                    // App name
                    // FadeTransition(
                    //   opacity: _fadeAnimation,
                    //   child: SlideTransition(
                    //     position: Tween<Offset>(
                    //       begin: const Offset(0, 20),
                    //       end: Offset.zero,
                    //     ).animate(_slideAnimation),
                    //     child: Text(
                    //       'HR Check-In APp',
                    //       style: TextStyleManager.font24SemiBold(context),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
