class UploadMediaModel {
  UploadMediaModel({
    this.data,
    this.code,
    this.message,
  });

  UploadMediaData? data;
  int? code;
  String? message;

  factory UploadMediaModel.fromJson(Map<String, dynamic> json) => UploadMediaModel(
    data: UploadMediaData.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class UploadMediaData {
  UploadMediaData({
    this.mediaId,
    this.status,
    this.contentType,
    this.fileLength,
    this.originalName,
    this.path,
    this.createdBy,
    this.created,
    this.updated,
  });

  int? mediaId;
  String? status;
  String? contentType;
  int? fileLength;
  String? originalName;
  String? path;
  String? createdBy;
  DateTime? created;
  DateTime? updated;

  factory UploadMediaData.fromJson(Map<String, dynamic> json) => UploadMediaData(
    mediaId: json["media_id"],
    status: json["status"],
    contentType: json["content_type"],
    fileLength: json["file_length"],
    originalName: json["original_name"],
    path: json["path"],
    createdBy: json["created_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );
}
