class ListProductDenomModel {
  ListProductDenomModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  int? count;
  bool? first;
  List<ListProductDenomData>? body;
  dynamic error;

  factory ListProductDenomModel.fromJson(Map<String, dynamic> json) => ListProductDenomModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: List<ListProductDenomData>.from(json["body"].map((x) => ListProductDenomData.fromJson(x))),
    error: json["error"],
  );
}

class ListProductDenomData {
  ListProductDenomData({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.type,
    this.group,
    this.category,
    this.adminFee,
    this.classId,
  });

  String? productId;
  String? name;
  String? description;
  dynamic price;
  String? type;
  String? group;
  String? category;
  dynamic adminFee;
  String? classId;

  factory ListProductDenomData.fromJson(Map<String, dynamic> json) => ListProductDenomData(
    productId: json["productId"],
    name: json["name"],
    description: json["description"],
    price: json["price"] ?? "",
    type: json["type"],
    group: json["group"],
    category: json["category"],
    adminFee: json["adminFee"] ?? "",
    classId: json["classId"],
  );
}
