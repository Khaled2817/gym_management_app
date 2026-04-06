import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PaginationFilterModel {
  int? page = 0;
  bool? hasNext;
  int? pageSize = 10;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["page"] = page;
    data["pageSize"] = pageSize;
    return data;
  }
}
class MyAttendanceDateFilterModel extends PaginationFilterModel {
  int? employeeId;
  DateTime? startDate;
  DateTime? endDate;
  bool? includeDeleted;
  Map<String, dynamic> toJson() {
    var data = super.toJson();
    data["employeeId"] = employeeId ?? 0;
    data["startDate"] = startDate?.toIso8601String();
    data["endDate"] = endDate?.toIso8601String();
    return data;
  }
}