import 'package:gym_management_app/core/dependancies_injection/di.dart';
import 'package:gym_management_app/core/helpers/spacing_helper.dart';
import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/pagination_widget.dart';
import 'package:gym_management_app/feature/attendance/data/model/attendance_record_model.dart';
import 'package:gym_management_app/feature/attendance/data/repo/attendance_repo.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_records_cubit.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_record_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAttendance extends StatelessWidget {
  const MyAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceRecordsCubit(getIt<AttendanceRepo>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            TextManager.myAttendance.tr(),
            style: TextStyleManager.font16Medium(
              context,
            ).copyWith(color: Colors.white),
          ),
          leading: SizedBox.shrink(),
          centerTitle: true,
        ),
        body: const MyAttendanceBody(),
      ),
    );
  }
}

class MyAttendanceBody extends StatefulWidget {
  const MyAttendanceBody({super.key});

  @override
  State<MyAttendanceBody> createState() => _MyAttendanceBodyState();
}

class _MyAttendanceBodyState extends State<MyAttendanceBody> {
  DateTime? startDate;
  DateTime? endDate;
  final GlobalKey<PaginationListScreenState> _paginationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initCubit();
  }

  Future<void> _initCubit() async {
    final cubit = context.read<AttendanceRecordsCubit>();
    await cubit.initEmployeeId();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceRecordsCubit>();

    return Column(
      children: [
        // Listv
        verticalSpace(20),
        Expanded(
          child: PaginationListScreen<AttendanceRecordModel>(
            key: _paginationKey,
            filter: cubit.filter,
            futurePageList: cubit.getAttendanceRecords,
            loader: const Center(
              child: CircularProgressIndicator(
                color: AppColorManager.primaryColor,
              ),
            ),
            listItem: (record) => AttendanceRecordCardWidget(record: record),
            fromList: AttendanceRecordModel.fromJsonList,
            padding: 0,
          ),
        ),
      ],
    );
  }
}
