class SosAgentModel {
  SosAgentModel({
    this.data,
  });

    List<SosAgentData>? data;

  factory SosAgentModel.fromJson(Map<String, dynamic> json) => SosAgentModel(
    data: List<SosAgentData>.from(json["data"].map((x) => SosAgentData.fromJson(x))),
  );
}

class SosAgentData {
  SosAgentData({
    this.uid,
    this.sender,
    this.acceptName,
    this.asName,
    this.signId,
    this.category,
    this.content,
    this.mediaUrlPhone,
    this.thumbnail,
    this.lat,
    this.lng,
    this.address,
    this.createdAt,
  });

  String? uid;
  Sender? sender;
  String? acceptName;
  String? asName;
  String? signId;
  String? category;
  String? content;
  String? mediaUrlPhone;
  String? thumbnail;
  String? lat;
  String? lng;
  String? address;
  DateTime? createdAt;

  factory SosAgentData.fromJson(Map<String, dynamic> json) => SosAgentData(
    uid: json["uid"],
    sender: Sender.fromJson(json["sender"]),
    acceptName: json["accept_name"],
    asName: json["as_name"],
    category: json["category"],
    signId: json["sign_id"],
    content: json["content"],
    mediaUrlPhone: json["media_url_phone"],
    thumbnail: json["thumbnail"],
    lat: json["lat"],
    lng: json["lng"],
    address: json["address"],
    createdAt: DateTime.parse(json["created_at"]
  ));
}

class Sender {
  Sender({
    this.name,
    this.fcm,
  });

  String? name;
  String? fcm;

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
    name: json["name"],
    fcm: json["fcm"],
  );
}
