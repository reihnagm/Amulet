class ContactModel {
  ContactModel({
    this.data,
  });

  List<ContactData>? data;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    data: List<ContactData>.from(json["data"].map((x) => ContactData.fromJson(x))),
  );
}

class ContactData {
  ContactData({
    this.id,
    this.uid,
    this.userId,
    this.name,
    this.identifier,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? uid;
  String? userId;
  String? name;
  String? identifier;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
    id: json["id"],
    uid: json["uid"],
    userId: json["user_id"],
    name: json["name"],
    identifier: json["identifier"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}
