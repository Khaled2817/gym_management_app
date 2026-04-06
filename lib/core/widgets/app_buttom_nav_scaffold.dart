import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_text.dart';

class NavItemModel {
  final String label;
  final IconData icon;
  final Widget page;

  const NavItemModel({
    required this.label,
    required this.icon,
    required this.page,
  });
}

class AppBottomNavScaffold extends StatefulWidget {
  final List<NavItemModel> items;
  final int initialIndex;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool keepPagesAlive;

  const AppBottomNavScaffold({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 260),
    this.animationCurve = Curves.easeOutCubic,
    this.keepPagesAlive = false,
  }) : assert(items.length >= 2 && items.length <= 5);

  @override
  State<AppBottomNavScaffold> createState() => _AppBottomNavScaffoldState();
}

class _AppBottomNavScaffoldState extends State<AppBottomNavScaffold> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _changeIndex(int index) {
    if (index == currentIndex) return;
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor =
        widget.selectedColor ?? AppColorManager.secondaryColor;
    final unselectedColor =
        widget.unselectedColor ??
        (isDark
            ? AppColorManagerDark.primaryColor
            : AppColorManager.primaryColor);
    final backgroundColor =
        widget.backgroundColor ??
        (isDark ? AppColorManagerDark.cardBackground : Colors.white);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: widget.keepPagesAlive
          ? IndexedStack(
              index: currentIndex,
              children: widget.items.map((e) => e.page).toList(),
            )
          : AnimatedSwitcher(
              duration: widget.animationDuration,
              switchInCurve: widget.animationCurve,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: KeyedSubtree(
                key: ValueKey(currentIndex),
                child: widget.items[currentIndex].page,
              ),
            ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 6),
          decoration: BoxDecoration(color: backgroundColor),
          child: Row(
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final isSelected = currentIndex == index;

              return Expanded(
                child: _BottomNavItem(
                  label: item.label,
                  icon: item.icon,
                  isSelected: isSelected,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                  duration: widget.animationDuration,
                  curve: widget.animationCurve,
                  onTap: () => _changeIndex(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final Duration duration;
  final Curve curve;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.duration,
    required this.curve,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: duration,
              curve: curve,
              width: isSelected ? 28 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: selectedColor.withValues(alpha: isSelected ? 1 : 0),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1, end: isSelected ? 1.08 : 1),
              duration: duration,
              curve: curve,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: AnimatedSwitcher(
                duration: duration,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Icon(
                  icon,
                  key: ValueKey('$label-$isSelected'),
                  size: 29,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // استخدام AppText للترجمة التلقائية
            AppText(
              text: label,
              styleBuilder: (context) => TextStyleManager.font14SemiBold(
                context,
              ).copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
