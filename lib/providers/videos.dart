import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/views/basewidgets/snackbar/snackbar.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panic_button/utils/constant.dart';
import 'package:uuid/uuid.dart';

enum ListenVStatus { idle, loading, loaded, empty, error }

class VideoProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  VideoProvider({
    required this.sharedPreferences
  });

  String _url = "";
  String get url => _url;

  String _fcm = "";
  String get fcm => _fcm;

  Future<String?> fetchFcm(BuildContext context) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get('${AppConstants.baseUrl}/fetch-fcm');
      Map<String, dynamic> data = res.data;
      String f = data["fcm_secret"];
      _fcm  = f;
      return _fcm;
    } on DioError catch(e) {
      if(e.response!.statusCode == 400 || e.response!.statusCode == 404 || e.response!.statusCode == 500 || e.response!.statusCode == 502) {
        debugPrint("(${e.response!.statusCode}) : Fetch FCM");
      }
    } catch(e) {
      debugPrint(e.toString());
    }
    return fcm;
  }

  Future<String?> uploadVideo(BuildContext context, {required File file}) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(
          file.path, 
          filename: basename(file.path)
        ),
      });
      Response res = await dio.post("${AppConstants.baseUrl}/upload", data: formData);
      Map<String, dynamic> resData = res.data;
      String url = resData["url"];
      _url = url;
      return _url;
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
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    } 
    return url;
  }

  Future<void> insertSos(BuildContext context, 
    {
      required String category,
      required String mediaUrl, 
      required String content,
      required String lat,
      required String lng
    }
  ) async {
    try {
      Dio dio = Dio();
      Response res = await dio.post('${AppConstants.baseUrl}/insert-sos', 
        data: {
          "uid": const Uuid().v4(),
          "category": category,
          "media_url": mediaUrl,
          "desc": content,
          "lat": lat,
          "lng": lng,
          "status": "sent"
        }
      );
      debugPrint("Insert SOS : ${res.statusCode}");
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
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}