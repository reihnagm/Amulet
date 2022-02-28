import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  TextEditingController otpTextController = TextEditingController();

  LoginStatus _loginStatus = LoginStatus.idle;
  LoginStatus get loginStatus => _loginStatus;

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

  String getUserFullname() {
    return authRepo.getUserFullName();
  }

  String getUserId() {
    return authRepo.getUserId()!;
  }

  bool isLoggedIn() {
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

  Future<void> logout(context) async {
    await deleteData();
    return Future.value();
  }

  Future<void> login(BuildContext context, User user) async {
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
      UserData userData = userModel.userData!;
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
      writeData(user.userData!);
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