import 'package:gym_management_app/core/dependancies_injection/di.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/pagination_widget.dart';
import 'package:gym_management_app/feature/attendance/data/model/attendance_record_model.dart';
import 'package:gym_management_app/feature/attendance/data/repo/attendance_repo.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_records_cubit.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_record_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceRecordsScreen extends StatelessWidget {
  const AttendanceRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceRecordsCubit(getIt<AttendanceRepo>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'سجل الحضور والانصراف',
            style: TextStyleManager.font16Medium(
              context,
            ).copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: const AttendanceRecordsBody(),
      ),
    );
  }
}

class AttendanceRecordsBody extends StatelessWidget {
  const AttendanceRecordsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceRecordsCubit>();

    return PaginationListScreen<AttendanceRecordModel>(
      filter: cubit.filter,
      futurePageList: cubit.getAttendanceRecords,
      loader: const Center(child: CircularProgressIndicator()),
      listItem: (record) => AttendanceRecordCardWidget(record: record),
      fromList: AttendanceRecordModel.fromJsonList,
    );
  }
}
