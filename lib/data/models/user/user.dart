class UserModel {
  UserModel({
    this.userData,
    this.code,
    this.message,
  });

  UserData? userData;
  int? code;
  String? message;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userData: UserData.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class UserData {
  UserData({
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  String? accessToken;
  String? refreshToken;
  User? user;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    user: User.fromJson(json["user"]),
  );
}

class User {
  User({
    this.emailActivated,
    this.emailAddress,
    this.address,
    this.fullname,
    this.password,
    this.identityNumber,
    this.phoneNumber,
    this.profilePic,
    this.role,
    this.status,
    this.userId,
  });

  int? emailActivated;
  dynamic? emailAddress;
  String? address;
  String? fullname;
  String? password;
  String? identityNumber;
  String?phoneNumber;
  String? profilePic;
  String? role;
  int? status;
  String? userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
    emailActivated: json["emailActivated"],
    emailAddress: json["emailAddress"],
    fullname: json["fullname"],
    identityNumber: json["identityNumber"],
    phoneNumber: json["phoneNumber"],
    profilePic: json["profilePic"],
    role: json["role"],
    status: json["status"],
    userId: json["userId"],
  );
}
