class AppPageListModel<T> {
  List data=[];
  bool hasNext = false;
  bool hasPrevious = false;
  int pageSize = 0;
  int totalPages = 0;
  int? currentPage = 0;
  AppPageListModel(data);
  AppPageListModel.fromJson(Map<String, dynamic> json) {
    hasNext = json["hasNext"];
    pageSize = json["pageSize"];
    hasPrevious = json["hasPrevious"];
    totalPages = json["totalPages"];
    currentPage = json["currentPage"] ?? 1;
    data = json["data"];
  }
}