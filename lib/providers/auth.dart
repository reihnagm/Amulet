import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:panic_button/data/repository/auth/auth.dart';
import 'package:panic_button/views/screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panic_button/utils/extension.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/views/basewidgets/snackbar/snackbar.dart';
import 'package:panic_button/data/models/user/user.dart';
import 'package:panic_button/utils/constant.dart';

enum LoginStatus { idle, loading, loaded, empty, error }
enum RegisterStatus { idle, loading, loaded, empty, error }

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;
  final SharedPreferences sharedPreferences;
  AuthProvider({
    required this.authRepo,
    required this.sharedPreferences
  });

  LoginStatus _loginStatus = LoginStatus.idle;
  LoginStatus get loginStatus => _loginStatus;

  RegisterStatus _registerStatus = RegisterStatus.idle;
  RegisterStatus get registerStatus => _registerStatus;


  void setStateLoginStatus(LoginStatus loginStatus) {
    _loginStatus = loginStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateRegisterStatus(RegisterStatus registerStatus) {
    _registerStatus = registerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  String getUserFullname() {
    return authRepo.getUserFullName();
  }

  String getUserId() {
    return authRepo.getUserId();
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
      writeData(userData);
      Navigator.pushReplacement(context,
      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
        return HomeScreen(key: UniqueKey());
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }));
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
      debugPrint("masuk sini");
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
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
      Response res = await dio.post("${AppConstants.baseUrlAmulet}/api-amulet/v1/auth/register", 
        data: {
          "identityNumber": user.identityNumber,
          "fullname": user.fullname!.capitalize(),
          "emailAddress": user.emailAddress,
          "phoneNumber": user.phoneNumber,
          "passowrd": user.password,
          "address": user.address
        }
      );
      Map<String, dynamic> resData = res.data;
      UserModel userModel = UserModel.fromJson(resData);
      UserData userData = userModel.userData!;
      writeData(userData);
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
        debugPrint(e.response!.data);
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
      setStateRegisterStatus(RegisterStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setStateRegisterStatus(RegisterStatus.error);
    }
  }

}