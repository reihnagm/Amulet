class SosModel {
  SosModel({
    this.data,
    this.total,
    this.perPage,
    this.nextPage,
    this.prevPage,
    this.currentPage,
    this.nextUrl,
    this.prevUrl,
  });

  List<SosData>? data;
  int? total;
  int? perPage;
  int? nextPage;
  int? prevPage;
  int? currentPage;
  String? nextUrl;
  String? prevUrl;

  factory SosModel.fromJson(Map<String, dynamic> json) => SosModel(
    data: List<SosData>.from(json["data"].map((x) => SosData.fromJson(x))),
    total: json["total"],
    perPage: json["perPage"],
    nextPage: json["nextPage"],
    prevPage: json["prevPage"],
    currentPage: json["currentPage"],
    nextUrl: json["nextUrl"],
    prevUrl: json["prevUrl"],
  );
}

class SosData {
  SosData({
    this.uid,
    this.category,
    this.mediaUrl,
    this.mediaUrlPhone,
    this.content,
    this.lat,
    this.lng,
    this.address,
    this.status,
    this.duration,
    this.thumbnail,
    this.signId,
    this.fullname,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  String? uid;
  String? category;
  dynamic mediaUrl;
  dynamic mediaUrlPhone;
  String? content;
  String? lat;
  String? lng;
  String? address;
  String? status;
  String? duration;
  String? thumbnail;
  String? signId;
  String? fullname;
  String? userId;
  dynamic createdAt;
  dynamic updatedAt;

  factory SosData.fromJson(Map<String, dynamic> json) => SosData(
    uid: json["uid"],
    category: json["category"],
    mediaUrl: json["media_url"],
    mediaUrlPhone: json["media_url_phone"],
    content: json["content"],
    lat: json["lat"],
    lng: json["lng"],
    address: json["address"],
    status: json["status"],
    duration: json["duration"],
    thumbnail: json["thumbnail"],
    signId: json["sign_id"],
    fullname: json["fullname"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );
}
