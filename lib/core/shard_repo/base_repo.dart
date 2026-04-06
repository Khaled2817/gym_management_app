// import 'package:dartz/dartz.dart';
// import 'package:gymtech/core/helper/core_helper.dart';
// import 'package:gymtech/data/models/base_model.dart';
// import 'package:gymtech/data/models/lookups/app_base_response_model.dart';
// import 'package:gymtech/data/models/lookups/dd_model.dart';
// import 'package:gymtech/data/models/pagination/pagination_filter_model.dart';
// import 'package:gymtech/data/models/pagination/pagination_model.dart';

// class BaseRepository<
//   T extends BaseModel,
//   FilterT extends PaginationFilterModel
// > {
//   final String controllerName;
//   final T Function(Map<String, dynamic>)? fromJson;
//   BaseRepository(this.controllerName, this.fromJson);
//   Future<Either<AppBaseResponseModel, List<DDModel<T>>>> getDropDownList<T>({
//     String? actionName,
//     T Function(dynamic id)? idParser, // ✅ custom parser
//   }) async {
//     final response = await Helper.dioConsumer.get(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? "GetDropDownList"}",
//     );

//     return response.fold((l) => Left(l), (r) {
//       // ✅ default parser = String
//       final parse = idParser ?? (dynamic x) => x.toString() as T;

//       final List<DDModel<T>> data = [];
//       for (final json in (r as List)) {
//         data.add(
//           DDModel<T>(
//             id: parse(json['id']),
//             name: (json['name'] ?? '').toString(),
//             parentId: json['parentId'],
//             isEnd: json['isEnd'],
//             vector: json['vector'],
//           ),
//         );
//       }
//       return Right(data);
//     });
//   }

//   Future<Either<AppBaseResponseModel, T>> baseGetById(
//     String? id, {
//     String? actionName,
//   }) async {
//     var response = await Helper.dioConsumer.get(
//       path: "$controllerName/${actionName ?? ""}$id",
//     );
//     return response.fold(
//       (l) => Left(l),
//       (r) => Right(fromJson != null ? fromJson!(r) : r),
//     );
//   }

//   Future<Either<AppBaseResponseModel, AppPageListModel>> getPagedList(
//     FilterT filter, {
//     String? actionName,
//   }) async {
//     var response = await Helper.dioConsumer.post(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       body: filter.toJson(),
//     );
//     return response.fold(
//       (l) => Left(l),
//       (r) => Right(AppPageListModel.fromJson(r)),
//     );
//   }

//   Future<Either<AppBaseResponseModel, AppPageListModel>> getPagedListGet(
//     FilterT filter, {
//     String? actionName,
//   }) async {
//     var response = await Helper.dioConsumer.get(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       body: filter.toJson(),
//     );
//     return response.fold(
//       (l) => Left(l),
//       (r) => Right(AppPageListModel.fromJson(r)),
//     );
//   }

//   Future<Either<AppBaseResponseModel, AppBaseResponseModel>> save(
//     T model, {
//     String? actionName,
//   }) async {
//     var response = await Helper.dioConsumer.post(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       body: model.toJson(),
//     );
//     return response.fold(
//       (l) => Left(l),
//       (r) => Right(AppBaseResponseModel.fromJson(r)),
//     );
//   }

//   Future<Either<AppBaseResponseModel, CustomReturnType>>
//   postModel<CustomReturnType>(
//     Map<String, dynamic> body,
//     CustomReturnType Function(Map<String, dynamic>) fromJsonCustomModel, {
//     String? actionName,
//     bool? isFormData,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var response = await Helper.dioConsumer.post(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       body: body,
//       isFormData: isFormData ?? false,
//       queryParameters: queryParameters,
//     );
//     return response.fold((l) => Left(l), (r) => Right(fromJsonCustomModel(r)));
//   }

//   Future<Either<AppBaseResponseModel, CustomReturnType>>
//   putModel<CustomReturnType>(
//   {
//     Map<String, dynamic>? jsonModel,
//     required CustomReturnType Function(Map<String, dynamic>)
//     fromJsonCustomModel,
//     String? actionName,
//     bool? isFormData,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var response = await Helper.dioConsumer.put(
//       isFormData: isFormData ?? false,
//       path: "$controllerName/${actionName ?? ''}",
//       body: jsonModel,
//       queryParameters: queryParameters,
//     );
//     return response.fold((l) => Left(l), (r) => Right(fromJsonCustomModel(r)));
//   }

//   Future<Either<AppBaseResponseModel, CustomT>> getModel<CustomT>(
//     CustomT Function(Map<String, dynamic>) fromJsonCustomModel, {
//     String? actionName,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? jsonModel,
//   }) async {
//     var response = await Helper.dioConsumer.get(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       queryParameters: queryParameters,
//       body: jsonModel,
//     );
//     return response.fold((l) => Left(l), (r) => Right(fromJsonCustomModel(r)));
//   }
//   // Future<Either<AppBaseResponseModel, CustomT>> putModel<CustomT>(
//   //   CustomT Function(Map<String, dynamic>) fromJsonCustomModel, {
//   //   String? actionName,
//   //   Map<String, dynamic>? queryParameters,
//   // }) async {
//   //   var response = await Helper.dioConsumer.put(
//   //     path: "$controllerName/${actionName ?? ''}",
//   //     queryParameters: queryParameters,
//   //   );
//   //   return response.fold((l) => Left(l), (r) => Right(fromJsonCustomModel(r)));
//   // }

//   Future<Either<AppBaseResponseModel, CustomT>> deleteModel<CustomT>(
//     CustomT Function(Map<String, dynamic>) fromJsonCustomModel, {
//     String? actionName,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var response = await Helper.dioConsumer.delete(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       queryParameters: queryParameters,
//     );
//     return response.fold((l) => Left(l), (r) => Right(fromJsonCustomModel(r)));
//   }

//   Future<Either<AppBaseResponseModel, CustomT>> patchModel<CustomT>(
//     CustomT Function(Map<String, dynamic>) fromJsonCustomModel, {
//     String? actionName,
//     Map<String, dynamic>? jsonModel,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var response = await Helper.dioConsumer.patch(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       queryParameters: queryParameters,
//       body: jsonModel,
//     );
//     return response.fold((l) => Left(l), (r) => Right(fromJsonCustomModel(r)));
//   }

//   Future<Either<AppBaseResponseModel, bool>> getModelAsBool<CustomT>(
//     CustomT Function(Map<String, dynamic>) fromJsonCustomModel, {
//     String? actionName,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var response = await Helper.dioConsumer.get(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       queryParameters: queryParameters,
//     );

//     return response.fold(
//       (error) =>
//           Left(error), // إذا كان هناك خطأ نرجع Left مع AppBaseResponseModel
//       (data) {
//         // هنا نحتاج للتحقق من نوع الـ data
//         if (data is bool) {
//           return Right(data); // إذا كانت الـ data من النوع bool نرجعها
//         } else {
//           // إذا كانت الـ data ليست من النوع bool نرجع false كقيمة افتراضية
//           return Right(false);
//         }
//       },
//     );
//   }

//   Future<Either<AppBaseResponseModel, String?>> getModelAsString({
//     String? actionName,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var response = await Helper.dioConsumer.get(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       queryParameters: queryParameters,
//     );

//     return response.fold(
//       (error) =>
//           Left(error), // إذا كان هناك خطأ نرجع Left مع AppBaseResponseModel
//       (data) {
//         // هنا نحتاج للتحقق من نوع الـ data
//         if (data is String?) {
//           return Right(data); // إذا كانت الـ data من النوع bool نرجعها
//         } else {
//           // إذا كانت الـ data ليست من النوع bool نرجع false كقيمة افتراضية
//           return Right(null);
//         }
//       },
//     );
//   }

//   Future<Either<AppBaseResponseModel, List<CustomT>>> getListModel<CustomT>(
//     List<CustomT> Function(List<Map<String, dynamic>>) fromJsonList, {
//     String? actionName,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var response = await Helper.dioConsumer.get(
//       path:
//           "$controllerName${actionName != null ? "/" : ''}${actionName ?? ''}",
//       queryParameters: queryParameters,
//     );
//     return response.fold(
//       (l) => Left(l),
//       (r) => Right(fromJsonList(List<Map<String, dynamic>>.from(r))),
//     );
//   }

//   Future<Either<AppBaseResponseModel, CustomListT>> getList<CustomListT>(
//     CustomListT Function(dynamic) fromJsonCustomModel, {
//     String? actionName,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var response = await Helper.dioConsumer.get(
//       path:
//           "$controllerName${actionName != null || actionName != "" ? "/" : ""}${actionName ?? ""}",
//       queryParameters: queryParameters,
//     );
//     return response.fold((l) => Left(l), (r) => Right(fromJsonCustomModel(r)));
//   }
// }