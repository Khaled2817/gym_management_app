import 'package:gym_management_app/core/api/token_storage.dart';
import 'package:gym_management_app/core/helpers/roles.dart';
import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/feature/attendance/ui/screen/my_attendance.dart';
import 'package:gym_management_app/feature/home/ui/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_app/core/widgets/app_buttom_nav_scaffold.dart';
import 'package:gym_management_app/feature/settings/ui/screen/settings_screen.dart';

class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  List<String> _roles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    final roles = await TokenStorage.getRoles();
    setState(() {
      _roles = roles;
      _isLoading = false;
    });
  }

  bool get hasMyAttendanceRole => _roles.contains(Roles.myAttendance);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final items = <NavItemModel>[
      NavItemModel(
        label: TextManager.home, // بدون .tr() - الـ AppText هتترجمه
        icon: Icons.home_outlined,
        page: const HomeScreen(),
      ),
      if (hasMyAttendanceRole)
        NavItemModel(
          label: TextManager.myAttendance, // بدون .tr()
          icon: Icons.check_circle_outline,
          page: const MyAttendance(),
        ),
      NavItemModel(
        label: TextManager.settings, // بدون .tr()
        icon: Icons.settings_outlined,
        page: const SettingsScreen(),
      ),
    ];

    return AppBottomNavScaffold(initialIndex: 0, items: items);
  }
}
