class DDModel<T> {
  final T id;
  String name = '';
  int? parentId;
  bool? isEnd;
  String? vector;
  DDModel({
    required this.id,
    required this.name,
    this.parentId,
    this.isEnd,
    this.vector,
  });

   static List<DDModel<T>> fromJsonList<T>(
    dynamic myList, {
    T Function(dynamic id)? idParser,
  }) {
    final parse = idParser ?? (dynamic x) => x.toString() as T;

    final List<DDModel<T>> data = [];
    for (final json in (myList as List)) {
      data.add(
        DDModel<T>(
          id: parse(json['id']),
          name: (json['name'] ?? '').toString(),
          parentId: json['parentId'],
          isEnd: json['isEnd'],
          vector: json['vector'],
        ),
      );
    }
    return data;
  }
}
  