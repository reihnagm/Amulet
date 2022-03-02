class InquiryPLNPrabayarModel {
  InquiryPLNPrabayarModel({
    this.code,
    this.message,
    this.data,
    this.error,
  });

  int? code;
  String? message;
  InquiryPLNPrabayarData? data;
  dynamic error;

  factory InquiryPLNPrabayarModel.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarModel(
    code: json["code"],
    message: json["message"],
    data: InquiryPLNPrabayarData.fromJson(json["body"]),
    error: json["error"],
  );

   
}

class InquiryPLNPrabayarData {
  InquiryPLNPrabayarData({
    this.inquiryStatus,
    this.productPrice,
    this.productId,
    this.productCode,
    this.productName,
    this.accountNumber1,
    this.accountNumber2,
    this.transactionId,
    this.transactionRef,
    this.data,
    this.classId,
  });

  String? inquiryStatus;
  dynamic productPrice;
  String? productId;
  String? productCode;
  String? productName;
  String? accountNumber1;
  String? accountNumber2;
  String? transactionId;
  String? transactionRef;
  InquiryPLNPrabayarUser? data;
  String? classId;

  factory InquiryPLNPrabayarData.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarData(
    inquiryStatus: json["inquiryStatus"],
    productPrice: json["productPrice"] ?? "",
    productId: json["productId"],
    productCode: json["productCode"],
    productName: json["productName"],
    accountNumber1: json["accountNumber1"],
    accountNumber2: json["accountNumber2"],
    transactionId: json["transactionId"],
    transactionRef: json["transactionRef"],
    data: InquiryPLNPrabayarUser.fromJson(json["data"]),
    classId: json["classId"],
  );

}

class InquiryPLNPrabayarUser {
  InquiryPLNPrabayarUser({
    this.accountName,
  });

  String? accountName;

  factory InquiryPLNPrabayarUser.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarUser(
    accountName: json["accountName"],
  );  
}
