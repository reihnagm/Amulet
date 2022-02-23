import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:amulet/data/models/inbox/inbox.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/constant.dart';
import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class InboxRepo {
  final SharedPreferences sharedPreferences;
  InboxRepo({
    required this.sharedPreferences
  });

  Future<InboxModel?> fetchInbox(BuildContext context, {required String userId}) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("${AppConstants.baseUrl}/inboxes/${userId}");
      Map<String, dynamic> data = res.data;
      return compute(parseInboxes, data);
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
    return null;
  }

  Future<void> insertInbox(BuildContext context, {required String title, required String content, required String userId}) async {
    try {
      Dio dio = Dio();
      await dio.post("${AppConstants.baseUrl}/inboxes/create", 
        data: {
          "uid": const Uuid().v4(),
          "title": title,
          "content": content,
          "user_id": userId
        }
      );
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

  Future<void> updateInbox(BuildContext context, {required String uid}) async {
    try {
      Dio dio = Dio();
      await dio.put("${AppConstants.baseUrl}/inboxes/update/$uid");
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

InboxModel inboxModel = InboxModel();


InboxModel parseInboxes(dynamic data) {
  InboxModel inboxModel = InboxModel.fromJson(data);
  return inboxModel;
}
