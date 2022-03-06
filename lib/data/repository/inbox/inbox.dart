import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:amulet/data/models/inbox/inbox.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/constant.dart';
import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';

class InboxRepo {
  final SharedPreferences sharedPreferences;
  InboxRepo({
    required this.sharedPreferences
  });

  Future<InboxModel?> getInbox(BuildContext context, {
    required String userId, 
    required int pageKey
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("${AppConstants.baseUrl}/inbox/${userId}?page=${pageKey}");
      Map<String, dynamic> data = res.data;
      return compute(parseGetInbox, data);
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

  Future<int> getInboxTotalUnread(BuildContext context, {
    required String userId, 
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("${AppConstants.baseUrl}/inbox/count/${userId}");
      Map<String, dynamic> data = res.data;
      return compute(parseGetInboxTotalUnread, data);
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
    return 0;
  }

  Future<void> storeInbox(BuildContext context, 
    {
      required String title, 
      required String content, 
      required String thumbnail,
      required String mediaUrl,
      required String type,
      required String userId
    }
  ) async {
    try {
      Dio dio = Dio();
      await dio.post("${AppConstants.baseUrl}/inbox/store", 
        data: {
          "uid": const Uuid().v4(),
          "title": title,
          "thumbnail": thumbnail,
          "media_url": mediaUrl,
          "content": content,
          "type": type,
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
      await dio.put("${AppConstants.baseUrl}/inbox/$uid/update");
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


InboxModel parseGetInbox(dynamic data) {
  InboxModel inboxModel = InboxModel.fromJson(data);
  return inboxModel;
}

int parseGetInboxTotalUnread(dynamic data) {
  return data["total_unread"];
}
