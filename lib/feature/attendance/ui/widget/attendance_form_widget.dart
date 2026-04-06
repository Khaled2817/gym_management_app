import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_reactive_form.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AttendanceFormWidget extends StatelessWidget {
  const AttendanceFormWidget({super.key});

  List<String> get predefinedNotes => [
    TextManager.workFromHome.tr(),
    TextManager.externalMeeting.tr(),
    TextManager.fieldTask.tr(),
    TextManager.remoteWork.tr(),
    TextManager.lateDueToTraffic.tr(),
    TextManager.earlyLeave.tr(),
    TextManager.emergencyLeave.tr(),
    TextManager.other.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: context.read<AttendanceCubit>().form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Predefined Notes Dropdown
          Text(
            TextManager.selectQuickNote.tr(),
            style: TextStyleManager.font14Medium(context),
          ),
          SizedBox(height: 8.h),
          _buildNotesDropdown(context),
          SizedBox(height: 16.h),
          // Custom Note Field
          Text(
            TextManager.additionalNote.tr(),
            style: TextStyleManager.font14Medium(context),
          ),
          SizedBox(height: 8.h),
          AppReactiveTextFormField(
            formControlName: 'note',
            hintText: TextManager.addNote.tr(),
            maxLines: 3,
            enabledBorderColor: AppColorManager.lighterGray,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesDropdown(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColorManagerDark.cardBackground
            : AppColorManager.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorManager.lighterGray),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              TextManager.selectNote.tr(),
              style: TextStyleManager.font14Medium(
                context,
              ).copyWith(color: AppColorManager.lightGray),
            ),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColorManager.primaryColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          borderRadius: BorderRadius.circular(12.r),
          dropdownColor: isDark
              ? AppColorManagerDark.cardBackground
              : AppColorManager.white,
          items: predefinedNotes.map((note) {
            return DropdownMenuItem(
              value: note,
              child: Text(note, style: TextStyleManager.font14Medium(context)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              final cubit = context.read<AttendanceCubit>();
              cubit.form.control('note').value = value;
            }
          },
        ),
      ),
    );
  }
}
