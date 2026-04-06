import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';

class NumberQuickSelector extends StatefulWidget {
  final int minNumber;
  final int maxNumber;
  final int initialValue;

  /// إجمالي عدد الأرقام الظاهرة بما فيهم الرقم الثابت 1
  final int visibleCount;
  final ValueChanged<int>? onChanged;

  const NumberQuickSelector({
    super.key,
    this.minNumber = 1,
    required this.maxNumber,
    this.initialValue = 1,
    this.visibleCount = 10,
    this.onChanged,
  });

  @override
  State<NumberQuickSelector> createState() => _NumberQuickSelectorState();
}

class _NumberQuickSelectorState extends State<NumberQuickSelector> {
  late int selectedNumber;
  late int startNumber;

  int get movingVisibleCount {
    // لأن الرقم الأول ثابت دائمًا
    final count = widget.visibleCount - 1;
    return count < 0 ? 0 : count;
  }

  @override
  void initState() {
    super.initState();
    selectedNumber = _clamp(widget.initialValue);
    startNumber = _calculateStartNumber(selectedNumber);
  }

  @override
  void didUpdateWidget(covariant NumberQuickSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue ||
        oldWidget.minNumber != widget.minNumber ||
        oldWidget.maxNumber != widget.maxNumber ||
        oldWidget.visibleCount != widget.visibleCount) {
      selectedNumber = _clamp(widget.initialValue);
      startNumber = _calculateStartNumber(selectedNumber);
    }
  }

  int _clamp(int value) {
    if (value < widget.minNumber) return widget.minNumber;
    if (value > widget.maxNumber) return widget.maxNumber;
    return value;
  }

  int _calculateStartNumber(int selected) {
    final movingMin = widget.minNumber + 1;

    if (widget.maxNumber <= widget.minNumber) {
      return widget.minNumber;
    }

    if (movingVisibleCount <= 0) {
      return movingMin;
    }

    // لو المختار 1 أو قريب من البداية
    if (selected <= movingMin) {
      return movingMin;
    }

    int start = selected;

    final maxStart = widget.maxNumber - movingVisibleCount + 1;

    if (start > maxStart) {
      start = maxStart;
    }

    if (start < movingMin) {
      start = movingMin;
    }

    return start;
  }

  List<int> _buildVisibleNumbers() {
    final List<int> numbers = [widget.minNumber];
    final movingMin = widget.minNumber + 1;

    if (movingMin > widget.maxNumber || movingVisibleCount <= 0) {
      return numbers;
    }

    for (int i = 0; i < movingVisibleCount; i++) {
      final number = startNumber + i;
      if (number <= widget.maxNumber && number != widget.minNumber) {
        numbers.add(number);
      }
    }

    return numbers;
  }

  void _selectNumber(int number) {
    final safeNumber = _clamp(number);

    setState(() {
      selectedNumber = safeNumber;
      startNumber = _calculateStartNumber(safeNumber);
    });

    widget.onChanged?.call(safeNumber);
  }

  @override
  Widget build(BuildContext context) {
    final numbers = _buildVisibleNumbers();

    return Wrap(
      spacing: 20.w,
      runSpacing: 10.w,
      children: numbers
          .map(
            (number) => _NumberItem(
              number: number,
              isSelected: selectedNumber == number,
              onTap: () => _selectNumber(number),
            ),
          )
          .toList(),
    );
  }
}

class _NumberItem extends StatelessWidget {
  final int number;
  final bool isSelected;
  final VoidCallback onTap;

  const _NumberItem({
    required this.number,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50.w,
        height: 50.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColorManager.primaryColor
              : Colors.grey.shade200,
          border: Border.all(
            color: isSelected
                ? AppColorManager.primaryColor
                : Colors.grey.shade400,
          ),
        ),
        child: Text(
          number.toString(),
          style: TextStyleManager.font16WhiteMedium(
            context,
          ).copyWith(color: isSelected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
