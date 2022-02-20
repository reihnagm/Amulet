import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panic_button/providers/videos.dart';
import 'package:panic_button/utils/constant.dart';

class FirebaseProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;

  FirebaseProvider({
    required this.sharedPreferences
  });

  Future<void> sendNotification(BuildContext context, {
    required String title,
    required String body,
  }) async {
    Map<String, dynamic> data = {};
    data = {
      "to": [],
      "collapse_key" : "Broadcast SOS",
      "priority":"high",
      "notification": {
        "title": title,
        "body": body,
        "sound":"default",
      },
      "android": {
        "notification": {
          "channel_id": "panicbutton",
        }
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
    };
    try { 
      Dio dio = Dio();
      await dio.post("https://fcm.googleapis.com/fcm/send", 
        data: data,
        options: Options(
          headers: {
            "Authorization": "key=${AppConstants.firebaseKey}"
          }
        )
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      debugPrint(e.response!.statusMessage.toString());
      debugPrint(e.response!.statusCode.toString());
    }
  }

}