import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import 'package:panic_button/services/notification.dart';
import 'package:panic_button/utils/global.dart';
import 'package:panic_button/utils/helper.dart';
import 'package:panic_button/views/screens/reports/index.dart';
import 'package:panic_button/utils/constant.dart';

class FirebaseProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;

  FirebaseProvider({
    required this.sharedPreferences
  });

  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  Future<void> setupInteractedMessage(BuildContext context) async {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      GlobalVariable.navState.currentState!.pushAndRemoveUntil(
        PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return ReportsScreen(key: UniqueKey());
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
        }), (Route<dynamic> route) => route.isFirst
      );  
    });
  }

  Future<void> init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      )
    );

    await notifications.initialize(
      settings,
      onSelectNotification: (String? payload) {
        onNotifications.add(payload!); 
      }
    );
  }

  void listenNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      // Map<String, dynamic> data = message.data;
      NotificationService.showNotification(
        id: Helper.createUniqueId(),
        title: notification.title,
        body: notification.body,
        payload: {},
      );
    });
  }

  Future<void> sendNotification(BuildContext context, {
    required String title,
    required String body,
    required List<String> tokens,
  }) async {
    Map<String, dynamic> data = {};
    data = {
      "registration_ids": tokens,
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