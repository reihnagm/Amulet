class SubscriptionModel {
  SubscriptionModel({
    this.data,
    this.code,
    this.message,
  });

  SubscriptionData? data;
  int? code;
  String? message;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
    data: SubscriptionData.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class SubscriptionData {
  SubscriptionData({
    this.subscriptionId,
    this.userId,
    this.days,
    this.activatedDate,
    this.expDate,
  });

  String? subscriptionId;
  String? userId;
  int? days;
  DateTime? activatedDate;
  DateTime? expDate;

  factory SubscriptionData.fromJson(Map<String, dynamic> json) => SubscriptionData(
    subscriptionId: json["subscriptionId"],
    userId: json["userId"],
    days: json["days"],
    activatedDate: DateTime.parse(json["activatedDate"]),
    expDate: DateTime.parse(json["expDate"]),
  );
}
