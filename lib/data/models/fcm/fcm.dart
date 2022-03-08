class FcmModel {
  FcmModel({
    this.data,
  });

  List<FcmData>? data;

  factory FcmModel.fromJson(Map<String, dynamic> json) => FcmModel(
    data: List<FcmData>.from(json["data"].map((x) => FcmData.fromJson(x))),
  );
}

class FcmData {
  FcmData({
    this.id,
    this.uid,
    this.fcmSecret,
    this.lat,
    this.lng,
    this.fullname,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? uid;
  String? fcmSecret;
  String? lat;
  String? lng;
  String? fullname;
  String? role;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FcmData.fromJson(Map<String, dynamic> json) => FcmData(
    id: json["id"],
    uid: json["uid"],
    fcmSecret: json["fcm_secret"],
    lat: json["lat"],
    lng: json["lng"],
    fullname: json["fullname"],
    role: json["role"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}
