import 'package:gym_management_app/core/shard_models.dart/pagenation_model.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaginationListScreen<E> extends StatefulWidget {
  dynamic filter;
  dynamic listItem;
  dynamic futurePageList;
  dynamic onTapListItem;
  Widget? loader;
  double? padding;
  List<Widget>? actions;
  dynamic fromList;
  String? title;

  PaginationListScreen({
    this.padding,
    this.loader,
    Key? key,
    required this.filter,
    required this.futurePageList,
    this.onTapListItem,
    this.listItem,
    this.fromList,
    this.actions,
    this.title,
  }) : super(key: key);

  @override
  PaginationListScreenState createState() => PaginationListScreenState();
}

class PaginationListScreenState extends State<PaginationListScreen> {
  TextEditingController searchController =
      TextEditingController(); // متحكم النص للبحث
  bool isLoading = true;
  List dataList = [];
  int currentPage = 1;
  int totalPages = 1;
  bool pagedLoading = false;
  // Timer? _debounce;
  @override
  void initState() {
    super.initState();
    getNext(isFirst: true); // تحميل أول مجموعة من البيانات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoading
          ? widget.loader ??
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColorManager.primaryColor,
                  ),
                )
          : dataList.isEmpty
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    color: AppColorManager.primaryColor,
                    size: 150.w,
                  ),
                  Text(
                    "No data found",
                    style: TextStyleManager.font16SemiBold(context),
                  ),
                ],
              ),
            )
          : NotificationListener<ScrollNotification>(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: widget.padding != null
                    ? EdgeInsets.all(widget.padding ?? 0)
                    : EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return widget.listItem(
                    dataList[index],
                  ); // عرض العنصر في القائمة
                },
              ),
              onNotification: (ScrollNotification scrollInfo) {
                getNext(scrollInfo: scrollInfo); // التحميل عند الوصول للأسفل
                return true;
              },
            ),
      bottomNavigationBar: pagedLoading
          ? SizedBox(
              height: 60.h,
              child: const Center(child: CircularProgressIndicator()),
            )
          : null,
    );
  }

  // دالة لتحميل البيانات مع الفلتر
  getNext({ScrollNotification? scrollInfo, bool? isFirst}) async {
    if ((scrollInfo != null &&
            widget.filter!.hasNext &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !isLoading &&
            !pagedLoading) ||
        isFirst == true) {
      if (isFirst == true) {
        setState(() {
          dataList.clear();
        });

        print(dataList); // مسح البيانات القديمة
        isLoading = true; // بدء التحميل
        widget.filter!.page = 0; // إعادة تعيين الصفحة
      } else {
        widget.filter!.page =
            widget.filter!.page + 1; // الانتقال للصفحة التالية
        pagedLoading = true; // تفعيل تحميل الصفحة
        setState(() {});
      } // استرجاع البيانات مع الفلتر
      AppPageListModel pageList = await widget.futurePageList(widget.filter);
      currentPage = pageList.currentPage ?? 1;
      totalPages = pageList.totalPages;
      dataList.addAll(widget.fromList(pageList.data)); // إضافة البيانات الجديدة
      widget.filter!.hasNext =
          pageList.hasNext; // تحديد إذا كان هناك صفحات أخرى
      isLoading = false; // إيقاف التحميل
      pagedLoading = false;
      setState(() {});
    }
  }

  setFilter(dynamic filter) {
    setState(() {
      widget.filter = filter;
    });
    // تعيين الفلتر الجديد
    getNext(isFirst: true); // تحميل البيانات مع الفلتر الجديد
  }
}
