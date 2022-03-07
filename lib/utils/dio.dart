import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amulet/views/screens/auth/sign_in.dart';
import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';

import 'package:amulet/localization/language_constraints.dart';

import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/constant.dart';

class DioManager {
  static final shared = DioManager();

  Future<Dio> getClient(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return null;
    };
    dio.options.connectTimeout = 15000;
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.headers = {
      "X-Context-ID": AppConstants.xContextId
    };
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        options.headers["Authorization"] = "Bearer ${sharedPreferences.getString("token")}";
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if(e.type == DioErrorType.connectTimeout) {
          ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
        }
        if(sharedPreferences.getString("token") != null) {
          bool isTokenExpired = JwtDecoder.isExpired(sharedPreferences.getString('token')!);
          if(isTokenExpired) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SignInScreen()), (Route<dynamic> route) => false);
          }
        }
        return handler.next(e);
      }
    ));
    return dio;  
  }

}
