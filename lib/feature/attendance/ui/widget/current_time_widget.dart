import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

class CurrentTimeWidget extends StatelessWidget {
  const CurrentTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final now = snapshot.data!;
        final hour = now.hour == 0
            ? 12
            : (now.hour > 12 ? now.hour - 12 : now.hour);
        final minute = now.minute.toString().padLeft(2, '0');
        final second = now.second.toString().padLeft(2, '0');
        final amPm = now.hour >= 12 ? 'PM' : 'AM';
        final timeString =
            '${hour.toString().padLeft(2, '0')}:$minute:$second $amPm';

        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];

        return Column(
          children: [
            Text(
              timeString,
              style: TextStyleManager.font32Bold(
                context,
              ).copyWith(color: AppColorManager.primaryColor),
            ),
          ],
        );
      },
    );
  }
}
