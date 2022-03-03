
class InboxModel {
  InboxModel({
    this.data,
    this.totalUnread,
    this.total,
    this.perPage,
    this.nextPage,
    this.prevPage,
    this.currentPage,
    this.nextUrl,
    this.prevUrl,
  });

  List<InboxData>? data;
  int? totalUnread;
  int? total;
  int? perPage;
  int? nextPage;
  int? prevPage;
  int? currentPage;
  String? nextUrl;
  String? prevUrl;

  factory InboxModel.fromJson(Map<String, dynamic> json) => InboxModel(
    data: List<InboxData>.from(json["data"].map((x) => InboxData.fromJson(x))),
    totalUnread: json["total_unread"],
    total: json["total"],
    perPage: json["perPage"],
    nextPage: json["nextPage"],
    prevPage: json["prevPage"],
    currentPage: json["currentPage"],
    nextUrl: json["nextUrl"],
    prevUrl: json["prevUrl"],
  );
}

class InboxData {
  InboxData({
    this.uid,
    this.isRead,
    this.title,
    this.type,
    this.content,
    this.mediaUrl,
    this.thumbnail,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  String? uid;
  int? isRead;
  String? title;
  String? type;
  String? content;
  String? mediaUrl;
  String? thumbnail;
  String? userId;
  String? createdAt;
  String? updatedAt;

  factory InboxData.fromJson(Map<String, dynamic> json) => InboxData(
    uid: json["uid"],
    isRead: json["is_read"],
    title: json["title"],
    type: json["type"],
    content: json["content"],
    mediaUrl: json["media_url"],
    thumbnail: json["thumbnail"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );
}
