import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.elevation = 0,
    this.height = kToolbarHeight,
    this.bottom,
    this.titleStyle,
  });

  final Widget title;
  final Gradient gradient;

  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final double elevation;
  final double height;
  final PreferredSizeWidget? bottom;
  final TextStyle? titleStyle;

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: height,
                child: NavigationToolbar(
                  leading: leading,
                  middle: DefaultTextStyle(
                    style: titleStyle ??
                        Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                    child: title,
                  ),
                  trailing: actions == null
                      ? null
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: actions!,
                        ),
                  centerMiddle: centerTitle,
                ),
              ),
              if (bottom != null) bottom!,
            ],
          ),
        ),
      ),
    );
  }
}