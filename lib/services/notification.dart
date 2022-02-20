import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future notificationDetails({required Map<String, dynamic> payload}) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'panicbutton',
      'panicbutton_channel',
      channelDescription: 'panicbutton_channel',
      importance: Importance.max, 
      priority: Priority.high,
      channelShowBadge: true,
      enableVibration: true,
      enableLights: true,
    );
    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: const IOSNotificationDetails(
        presentBadge: true,
        presentSound: true,
        presentAlert: true,
      ),
    );
  } 

  static Future init({bool initScheduled = true}) async {
    InitializationSettings settings =  const InitializationSettings(
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

    // * When app is closed 
    final details = await notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload ?? "");
    }

    await notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload!);
      }
    );

    if(initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int? id,
    String? title, 
    String? body,
    Map<String, dynamic>? payload,
  }) async {
    notifications.show(
      id!, 
      title, 
      body, 
      await notificationDetails(payload: payload!),
      payload: ""
    );
  }

}