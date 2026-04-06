import 'package:gym_management_app/core/api/token_storage.dart';
import 'package:gym_management_app/core/dependancies_injection/di.dart';
import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_profile_image.dart';
import 'package:gym_management_app/core/widgets/app_text.dart';
import 'package:gym_management_app/feature/attendance/data/repo/attendance_repo.dart';
import 'package:gym_management_app/feature/notification/ui/screen/notification_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_cubit.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_states.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/statistics_cubit.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/statistics_states.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_card_shimmer.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_card_widget.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/monthly_statistics_widget.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/statistics_shimmer.dart';
import 'package:gym_management_app/feature/home/ui/widget/attendance_error_card_widget.dart';
import 'package:gym_management_app/feature/home/ui/widget/attendance_nav_card_widget.dart';
import 'package:gym_management_app/feature/home/ui/widget/statistics_error_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await TokenStorage.getName();
    setState(() {
      _userName = name;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AttendanceCubit(getIt<AttendanceRepo>())..getCurrentAttendance(),
        ),
        BlocProvider(
          create: (context) =>
              StatisticsCubit(getIt<AttendanceRepo>())..getMonthlyStatistics(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Custom Header with Profile and Notification
                _buildHeader(context, isDark),
                SizedBox(height: 20.h),
                // Navigation Card
                Builder(
                  builder: (context) {
                    return AttendanceNavCardWidget(
                      onRefreshAttendance: () => context
                          .read<AttendanceCubit>()
                          .getCurrentAttendance(),
                      onRefreshStatistics: () => context
                          .read<StatisticsCubit>()
                          .getMonthlyStatistics(),
                    );
                  },
                ),
                SizedBox(height: 24.h),
                // Attendance Card
                BlocBuilder<AttendanceCubit, AttendanceStates>(
                  builder: (context, state) {
                    if (state is AttendanceCurrentLoaded) {
                      return AttendanceCardWidget(attendance: state.attendance);
                    } else if (state is AttendanceLoading) {
                      return const AttendanceCardShimmer();
                    } else {
                      return const AttendanceErrorCardWidget();
                    }
                  },
                ),
                SizedBox(height: 24.h),
                // Monthly Statistics
                BlocBuilder<StatisticsCubit, StatisticsStates>(
                  builder: (context, state) {
                    if (state is StatisticsLoaded) {
                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: MonthlyStatisticsWidget(
                          statistics: state.statistics,
                        ),
                      );
                    } else if (state is StatisticsLoading) {
                      return const StatisticsShimmer();
                    } else if (state is StatisticsError) {
                      return StatisticsErrorCardWidget(error: state.error);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Profile Image
          AppProfileImage(userName: _userName, radius: 24.r),
          SizedBox(width: 12.w),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyleManager.font12Medium(context).copyWith(
                    color: isDark
                        ? AppColorManagerDark.gray
                        : AppColorManager.gray,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _userName.isNotEmpty ? _userName : 'User',
                  style: TextStyleManager.font16SemiBold(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Notification Icon
          _buildNotificationIcon(context, isDark),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColorManagerDark.cardBackground
            : AppColorManager.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.notifications_outlined,
          color: isDark
              ? AppColorManagerDark.primaryColor
              : AppColorManager.primaryColor,
          size: 24.sp,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          );
        },
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return TextManager.goodMorning.tr();
    } else if (hour < 17) {
      return TextManager.goodAfternoon.tr();
    } else {
      return TextManager.goodEvening.tr();
    }
  }
}
