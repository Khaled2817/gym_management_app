import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/shard_models.dart/dd_model.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';

class DropDownButtonInput extends StatefulWidget {
  final String hintText;

  /// لو عندك ليست جاهزة
  final List<DDModel>? items;

  /// لو هتجيب الداتا من API (بدون dartz)
  final Future<List<DDModel>> Function()? getData;

  final Function(int?)? onChanged;
  final FormFieldValidator<int?>? validator;

  /// selected value
  final int? selectedId;

  /// Optional overrides
  final Color? borderColor;
  final Color? iconColor;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;

  const DropDownButtonInput({
    super.key,
    required this.hintText,
    this.items,
    this.getData,
    required this.onChanged,
    this.validator,
    this.selectedId,
    this.borderColor,
    this.iconColor,
    this.fillColor,
    this.borderRadius,
    this.padding,
    this.hintTextStyle,
    this.textStyle,
    this.errorTextStyle,
  });

  @override
  State<DropDownButtonInput> createState() => _DropDownButtonInputState();
}

class _DropDownButtonInputState extends State<DropDownButtonInput> {
  List<DDModel> _cachedItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void didUpdateWidget(covariant DropDownButtonInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items != null && widget.items != oldWidget.items) {
      _cachedItems = widget.items!;
    }

    if (widget.getData != oldWidget.getData) {
      _loadItems();
    }
  }

  Future<void> _loadItems() async {
    // ✅ لو items جاهزة
    if (widget.items != null) {
      setState(() {
        _cachedItems = widget.items!;
        _errorMessage = null;
      });
      return;
    }

    // ✅ لو مفيش getData
    if (widget.getData == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await widget.getData!();
      setState(() {
        _cachedItems = items;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load items';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ كستم على ألوانك
    final primary = AppColorManager.primaryColor;

    final Color effectiveBorderColor =
        widget.borderColor ?? AppColorManager.primaryColor.withOpacity(0.25);

    final Color effectiveFocusedBorderColor =
        widget.borderColor ?? AppColorManager.primaryColor;

    final Color effectiveIconColor = widget.iconColor ?? primary;

    final Color effectiveFillColor =
        widget.fillColor ?? AppColorManager.backGroundFeildColor;

    final BorderRadius effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(16.r);

    final EdgeInsetsGeometry effectivePadding =
        widget.padding ??
        EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h);

    final TextStyle effectiveHintTextStyle =
        widget.hintTextStyle ??
        TextStyleManager.font14LightGrayRegular(context);

    final TextStyle effectiveTextStyle =
        widget.textStyle ?? TextStyleManager.font13Medium(context);

    final TextStyle effectiveErrorTextStyle =
        widget.errorTextStyle ?? TextStyle(color: Colors.red, fontSize: 12.sp);

    if (_errorMessage != null) {
      return _buildErrorWidget(_errorMessage!, effectiveErrorTextStyle);
    }

    return DropdownButtonFormField2<int>(
      key: ValueKey<int?>(widget.selectedId == 0 ? null : widget.selectedId),
      decoration: InputDecoration(
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding: effectivePadding,

        border: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: BorderSide(
            color: effectiveFocusedBorderColor,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: const BorderSide(color: Colors.red, width: 1.6),
        ),
        errorStyle: effectiveErrorTextStyle,
      ),
      isExpanded: true,

      hint: Text(widget.hintText, style: effectiveHintTextStyle),

      value: widget.selectedId == 0 ? null : widget.selectedId,

      validator: widget.validator,

      onChanged: widget.onChanged,

      items: _cachedItems.map((item) {
        return DropdownMenuItem<int>(
          value: item.id,
          child: Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: effectiveTextStyle,
          ),
        );
      }).toList(),

      iconStyleData: IconStyleData(
        icon: _isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(primary),
                ),
              )
            : Icon(
                Icons.keyboard_arrow_down_rounded,
                color: effectiveIconColor,
              ),
        iconSize: 26.w,
      ),

      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: effectiveBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 6.h),
      ),

      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        height: 44.h,
      ),
    );
  }

  Widget _buildErrorWidget(String errorMessage, TextStyle errorStyle) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColorManager.backGroundFeildColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16.r),
        ),
        errorText: errorMessage,
        errorStyle: errorStyle,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.hintText,
            style: TextStyleManager.font14LightGrayRegular(context),
          ),
          const Icon(Icons.error_outline, color: Colors.red),
        ],
      ),
    );
  }
}
