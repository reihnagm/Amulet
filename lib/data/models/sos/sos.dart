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
    this.content,
    this.lat,
    this.lng,
    this.address,
    this.status,
    this.duration,
    this.thumbnail,
    this.fullname,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  String? uid;
  String? category;
  String? mediaUrl;
  String? content;
  String? lat;
  String? lng;
  String? address;
  String? status;
  String? duration;
  String? thumbnail;
  String? fullname;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SosData.fromJson(Map<String, dynamic> json) => SosData(
    uid: json["uid"],
    category: json["category"],
    mediaUrl: json["media_url"],
    content: json["content"],
    lat: json["lat"],
    lng: json["lng"],
    address: json["address"],
    status: json["status"],
    duration: json["duration"],
    thumbnail: json["thumbnail"],
    fullname: json["fullname"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}