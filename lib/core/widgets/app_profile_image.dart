import 'package:cached_network_image/cached_network_image.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final double radius;
  final VoidCallback? onTap;

  const AppProfileImage({
    super.key,
    this.imageUrl,
    this.userName,
    this.radius = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? AppColorManagerDark.secondaryColor
                : AppColorManager.primaryColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(child: _buildImageContent(context, isDark)),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context, bool isDark) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: isDark
              ? AppColorManagerDark.cardBackground
              : AppColorManager.primaryColor.withValues(alpha: 0.1),
          child: Center(
            child: SizedBox(
              width: radius * 0.8,
              height: radius * 0.8,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColorManager.primaryColor,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(isDark),
      );
    }
    return _buildPlaceholder(isDark);
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark
          ? AppColorManagerDark.cardBackground
          : AppColorManager.primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: userName != null && userName!.isNotEmpty
            ? Text(
                _getInitials(userName!),
                style: TextStyle(
                  fontSize: radius * 0.7,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColorManagerDark.secondaryColor
                      : AppColorManager.primaryColor,
                ),
              )
            : Icon(
                Icons.person,
                size: radius,
                color: isDark
                    ? AppColorManagerDark.secondaryColor
                    : AppColorManager.primaryColor,
              ),
      ),
    );
  }

  String _getInitials(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return '';

    final parts = trimmedName.split(RegExp(r'\s+'));
    // Filter out empty strings that might result from multiple spaces
    final nonEmptyParts = parts.where((part) => part.isNotEmpty).toList();

    if (nonEmptyParts.isEmpty) return '';
    if (nonEmptyParts.length == 1) {
      return nonEmptyParts[0][0].toUpperCase();
    }
    return '${nonEmptyParts[0][0]}${nonEmptyParts[1][0]}'.toUpperCase();
  }
}
