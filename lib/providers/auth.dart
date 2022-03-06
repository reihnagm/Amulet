import 'dart:convert';

import 'package:amulet/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amulet/utils/exceptions.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/data/models/inquiry/register.dart';
import 'package:amulet/views/screens/auth/sign_in.dart';
import 'package:amulet/views/screens/auth/otp.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/data/repository/auth/auth.dart';
import 'package:amulet/services/navigation.dart';
import 'package:amulet/views/screens/home/home.dart';
import 'package:amulet/utils/extension.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';
import 'package:amulet/data/models/user/user.dart';
import 'package:amulet/utils/constant.dart';

enum AuthDisbursementStatus { loading, loaded, error, idle } 
enum LoginStatus { idle, loading, loaded, empty, error }
enum RegisterStatus { idle, loading, loaded, empty, error }
enum ResendOtpStatus { idle, loading, loaded, error, empty } 
enum VerifyOtpStatus { idle, loading, loaded, error, empty }
enum ApplyChangeEmailOtpStatus { idle, loading, loaded, error, empty }

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;
  final NavigationService navigationService;
  final SharedPreferences sharedPreferences;
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 10 * 1000, // 10 seconds
      receiveTimeout: 10 * 1000 // 10 seconds
    )
  );
  AuthProvider({
    required this.authRepo,
    required this.navigationService,
    required this.sharedPreferences
  });

  bool changeEmail = true;
  String? otp;
  String whenCompleteCountdown = "start";
  String changeEmailName = "";
  String emailCustom = "";

  InquiryRegisterModel? inquiryRegisterModel;

  TextEditingController otpTextController = TextEditingController();

  LoginStatus _loginStatus = LoginStatus.idle;
  LoginStatus get loginStatus => _loginStatus;

  AuthDisbursementStatus _authDisbursementStatus = AuthDisbursementStatus.idle;
  AuthDisbursementStatus get authDisbursementStatus => _authDisbursementStatus;

  RegisterStatus _registerStatus = RegisterStatus.idle;
  RegisterStatus get registerStatus => _registerStatus;

  VerifyOtpStatus _verifyOtpStatus = VerifyOtpStatus.idle;
  VerifyOtpStatus get verifyOtpStatus => _verifyOtpStatus;

  ResendOtpStatus _resendOtpStatus = ResendOtpStatus.idle;
  ResendOtpStatus get resendOtpStatus => _resendOtpStatus;

  ApplyChangeEmailOtpStatus _applyChangeEmailOtpStatus = ApplyChangeEmailOtpStatus.idle;
  ApplyChangeEmailOtpStatus get applyChangeEmailOtpStatus => _applyChangeEmailOtpStatus;

  void setStateLoginStatus(LoginStatus loginStatus) {
    _loginStatus = loginStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateRegisterStatus(RegisterStatus registerStatus) {
    _registerStatus = registerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setVerifyOtpStatus(VerifyOtpStatus verifyOtpStatus) {
    _verifyOtpStatus = verifyOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setResendOtpStatus(ResendOtpStatus resendOtpStatus) {
    _resendOtpStatus = resendOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus applyChangeEmailOtpStatus) {
    _applyChangeEmailOtpStatus = applyChangeEmailOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  
  void setStateAuthDisbursement(AuthDisbursementStatus authDisbursementStatus) {
    _authDisbursementStatus = authDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  String? getUserPhone() {
    return authRepo.getUserPhone();
  }

  String? getUserFullname() {
    return authRepo.getUserFullName();
  }

  String? getUserId() {
    return authRepo.getUserId();
  }

  bool? isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  void writeData(UserData user) {
    sharedPreferences.setString("token", user.accessToken!);
    sharedPreferences.setString("refreshToken", user.refreshToken!);
    sharedPreferences.setString("user", json.encode({
      "userId": user.user!.userId,
      "identityNumber": user.user!.identityNumber,
      "fullname": user.user!.fullname,
      "email": user.user!.emailAddress,
      "emailActivated": user.user!.emailActivated,
      "phone": user.user!.phoneNumber,
      "profilePic": user.user!.profilePic,
      "role": user.user!.role,
      "status": "enabled",
    }));
  }
  
  Future<void> deleteData() async {
    sharedPreferences.remove("token");
    sharedPreferences.remove("refreshToken");
    sharedPreferences.remove("user");
  }

  Future authDisbursement(BuildContext context, String password) async {
    setStateAuthDisbursement(AuthDisbursementStatus.loading);
    try {
      Response res = await dio.post("${AppConstants.baseUrl}/user-service/authentication-disburse", data: {
        "password": password
      }, options: Options(
        headers: {
          "Authorization": "Bearer ${sharedPreferences.getString("token")}"
        }
      ));
      setStateAuthDisbursement(AuthDisbursementStatus.loaded);
      return res.statusCode;
    } on DioError catch(e) {
      setStateAuthDisbursement(AuthDisbursementStatus.error);
      if(e.response?.statusCode == 400) {
        throw CustomException(json.decode(e.response!.data)["error"]);
      }
    } catch(e) {
      setStateAuthDisbursement(AuthDisbursementStatus.error);
      debugPrint(e.toString());
    }
  }

  Future<void> logout(context) async {
    await deleteData();
    return Future.value();
  }

  Future<InquiryRegisterModel> verify(BuildContext context, GlobalKey<ScaffoldState> globalKey, User user) async {
    String productId = "";
    if(user.role! == "1d") {
      productId = "df78a1a0-9d5b-4a7c-bd48-d4395f207436"; // 30 K
    } else {
      productId = "92e1affe-467b-4b2a-a329-019c55fb53a9"; // 300 K
    }
    debugPrint(productId);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlPpob}/registration/inquiry", data: {
        "productId" : productId
      });
      debugPrint(res.statusCode.toString());
      // Map<String, dynamic> resData = res.data;
      // InquiryRegisterModel inquiryRegisterModel = InquiryRegisterModel.fromJson(resData); 
      // return inquiryRegisterModel;  
    } on DioError catch(e) {    
      debugPrint(e.response!.statusCode.toString());
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
    return inquiryRegisterModel!;
  }

  Future<void> login(BuildContext context, GlobalKey<ScaffoldState> globalKey, User user) async {
    setStateLoginStatus(LoginStatus.loading);
    try {
      Dio dio = Dio();
      Response res = await dio.post("${AppConstants.baseUrlAmulet}/api-amulet/v1/auth/login", 
        data: {
          "phoneNumber": user.phoneNumber,
          "password": user.password
        }
      );
      Map<String, dynamic> resData = res.data;
      UserModel userModel = UserModel.fromJson(resData);
      UserData userData = userModel.data!;
      // InquiryRegisterModel inquiryRegisterModel = await verify(context, globalKey, userData.accessToken!, userModel);
      // if(inquiryRegisterModel.code == 0) {
      //   sharedPreferences.setString("pay_register_token", userData.accessToken!);
      //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyScreen(
      //     accountName: inquiryRegisterModel.body!.data!.accountName!,
      //     accountNumber: inquiryRegisterModel.body!.accountNumber2!,
      //     bankFee: inquiryRegisterModel.body!.data!.bankFee!,
      //     transactionId: inquiryRegisterModel.body!.transactionId!,
      //     productId: inquiryRegisterModel.body!.productId!,
      //     productPrice: inquiryRegisterModel.body!.productPrice!,
      //   )));
      // } else {
      //   if(userData.user!.status == "enabled" &&  userModel.data!.user!.emailActivated == 1) {
      //     writeData(userData);
      //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(key: UniqueKey())));
      //   } else {
      //     sharedPreferences.setString("email_otp", userModel.data!.user!.emailAddress!);
      //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OtpScreen(key: UniqueKey())));
      //   }
      // }
      if(userData.user!.emailActivated != 0) {
        writeData(userData);
        navigationService.pushNavReplacement(
          context, 
          HomeScreen(key: UniqueKey())
        );
      } else {
        sharedPreferences.setString("email_otp", userData.user!.emailAddress!);
        navigationService.pushNavReplacement(
          context,
          OtpScreen(key: UniqueKey())
        );
      }
      setStateLoginStatus(LoginStatus.loaded);
    } on DioError catch(e) {  
      if(
      e.response!.statusCode == 400
      || e.response!.statusCode == 401
      || e.response!.statusCode == 402 
      || e.response!.statusCode == 403
      || e.response!.statusCode == 404 
      || e.response!.statusCode == 405 
      || e.response!.statusCode == 500 
      || e.response!.statusCode == 501
      || e.response!.statusCode == 502
      || e.response!.statusCode == 503
      || e.response!.statusCode == 504
      || e.response!.statusCode == 505
    ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error ( ${e.response?.data["error"]} )", "", ColorResources.purpleDark);
      }
      setStateLoginStatus(LoginStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setStateLoginStatus(LoginStatus.error);
    }
  }

  Future<void> register(BuildContext context, User user) async {
    setStateRegisterStatus(RegisterStatus.loading);
    try {
      Dio dio = Dio();
      await dio.post("${AppConstants.baseUrlAmulet}/api-amulet/v1/auth/register", 
        data: {
          "identityNumber": user.identityNumber,
          "fullname": user.fullname!.capitalize(),
          "emailAddress": user.emailAddress,
          "phoneNumber": user.phoneNumber,
          "password": user.password,
          "address": user.address
        }
      );
      // Map<String, dynamic> resData = res.data;
      // UserModel userModel = UserModel.fromJson(resData);
      // UserData userData = userModel.userData!;
      // writeData(userData);
      navigationService.pushNavReplacement(context, SignInScreen(key: UniqueKey()));
      setStateRegisterStatus(RegisterStatus.loaded);
    } on DioError catch(e) {  
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error ( ${e.response?.data["error"]} )", "", ColorResources.purpleDark);
      }
      setStateRegisterStatus(RegisterStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setStateRegisterStatus(RegisterStatus.error);
    }
  }

  void cleanText() {
    otpTextController.text = "";
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void cancelCustomEmail() {
    changeEmail = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

   void changeEmailCustom() {
    changeEmail = !changeEmail;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void emailCustomChange(String val) {
    emailCustom = val;
    Future.delayed(Duration.zero, () => notifyListeners());
  } 

  void completeCountDown() {
    whenCompleteCountdown = "completed";
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void otpCompleted(v) {
    otp = v;
    notifyListeners();
  } 

  Future<void> applyChangeEmailOtp(BuildContext context,  GlobalKey<ScaffoldState> globalKey) async {
    changeEmailName = sharedPreferences.getString("email_otp")!;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(changeEmailName); 
    if(!emailValid) {
      ShowSnackbar.snackbar(context, "Ex : customcare@connexist.com", "", ColorResources.error);
      return;
    } else {
      if(emailCustom.trim().isNotEmpty) {
        changeEmailName = emailCustom;
      }
      Future.delayed(Duration.zero, () => notifyListeners());
    }
    try {
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.loading);
      await dio.post("${AppConstants.baseUrl}/user-service/change-email", data: {
        "old_email": sharedPreferences.getString("email_otp"),
        "new_email": changeEmailName
      });
      sharedPreferences.setString("email_otp", changeEmailName);
      ShowSnackbar.snackbar(context, getTranslated("UPDATE_CHANGE_EMAIL_SUCCESSFUL", context), "", ColorResources.success);
      changeEmail = true;
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.loaded);
    } on DioError catch(e) {
      ShowSnackbar.snackbar(context, json.decode(e.response?.data)["error"], "", ColorResources.error);
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error);
    }
  }

  Future<void> verifyOtp(BuildContext context, GlobalKey<ScaffoldState> globalKey) async {
    if(otp == null) {
      ShowSnackbar.snackbar(context, "Mohon Masukan OTP Anda", "", ColorResources.error);
      return;
    }
    setVerifyOtpStatus(VerifyOtpStatus.loading);
    try {
      Response res = await dio.post("${AppConstants.baseUrlAmulet}/api-amulet/v1/auth/verify-otp",
        data: {
          "otp": otp,
          "email": changeEmailName
        }
      );
      ShowSnackbar.snackbar(context, "Akun Alamat E-mail $changeEmailName Anda sudah aktif", "", ColorResources.success);
      Map<String, dynamic> data = res.data;
      UserModel user = UserModel.fromJson(data);
      writeData(user.data!);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(key: UniqueKey()))
      ); 
      setVerifyOtpStatus(VerifyOtpStatus.loaded);
    } on DioError catch(e) {
      if(e.response?.statusCode == 400 || e.response?.statusCode == 401 || e.response?.statusCode == 500) {
        ShowSnackbar.snackbar(context, "${e.response!.statusCode.toString()} : Internal Server Error", "", ColorResources.error);
      }
      setVerifyOtpStatus(VerifyOtpStatus.error);
    } catch(e) {
      ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
      setVerifyOtpStatus(VerifyOtpStatus.error);
    }
  }

  Future<void> resendOtpCall(BuildContext context, GlobalKey<ScaffoldState> globalKey) async {
    try {
      whenCompleteCountdown = "start";
      Future.delayed(Duration.zero, () => notifyListeners());
      await resendOtp(context, globalKey, changeEmailName);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> resendOtp(BuildContext context, GlobalKey<ScaffoldState> globalKey, String email) async {
    setResendOtpStatus(ResendOtpStatus.loading);
    try {
      await dio.post("${AppConstants.baseUrl}/user-service/resend-otp",
        data: {
          "email": email
        }
      );
      ShowSnackbar.snackbar(context, "Silahkan periksa Alamat E-mail $email Anda, untuk melihat kode OTP yang tercantum", "", ColorResources.success);
      setResendOtpStatus(ResendOtpStatus.loaded);
    } on DioError catch(e) {
      if(e.response?.statusCode == 400 || e.response?.statusCode == 401 || e.response?.statusCode == 500) {
        ShowSnackbar.snackbar(context, "${e.response!.statusCode.toString()} : Internal Server Error", "", ColorResources.error);
      }
      setResendOtpStatus(ResendOtpStatus.error);
    } catch(e) {
      ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
      setResendOtpStatus(ResendOtpStatus.error);
    }
  }

}