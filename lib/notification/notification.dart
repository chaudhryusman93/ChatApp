import 'dart:convert';
// import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';

void triggerNotifiation(
    {required String tittle,
    required String body,
    required var tokenId}) async {
  try {
    await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'content-type': 'application/json',
          'Authorization':
              'key=AAAA4t8zXso:APA91bHZILlEft2oDJQ4hHRmIeczSYERhFcGWdnv3J3FsiwIK_ONEzRkBbfR-QjMbFsjkvde-UfPqqF4yx4oQwZMijyQSOc5u4kSjS4bIauGG6-L0TnURtwtqCiCFoiZEz3fcteCTy3I'
        },
        body: jsonEncode(
          <String, dynamic>{
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "status": "done",
            },
            "notification": <String, dynamic>{
              "title": tittle,
              "body": body,
              "channel": "chatter",
              "priority": "high",
              "alert": true,
            },
            "to": tokenId
          },
        ));
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }

  // class LocalNotificationService {
//   static LocalNotificationService? localNotificationService;
//   LocalNotificationService.internal();

//   factory LocalNotificationService() {
//     return localNotificationService ??= LocalNotificationService.internal();
//   }

//   //make the instance of the flutter local notification
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   //method to initialize the notification setting
//   Future<void> initializeSettingsOfNotifications() async {
//     // for Android
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/launcher_icon.png');

//     // for IOS
//     const DarwinInitializationSettings darwinInitializationSettings =
//         DarwinInitializationSettings(
//             requestSoundPermission: false,
//             requestBadgePermission: false,
//             requestAlertPermission: false);

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: androidInitializationSettings,
//             iOS: darwinInitializationSettings,
//             macOS: null);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     // for Android
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'chaticious',
//       'chatBuddy channel',
//       enableVibration: true,
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     // for IOS
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails();

//     const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);

//     await flutterLocalNotificationsPlugin
//         .show(2, title, body, notificationDetails, payload: 'data');
//   }
// }

// class FirebaseApi {
//   //create instence of fibase message
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   //function for initilize the notification
//   Future<void> initNotification() async {
//     await _firebaseMessaging.requestPermission();
//   }

//   // fetch FCM token from device
//   // Future<String> getDeviceToken() async {
//   //   String? token = await _firebaseMessaging.getToken();
//   //   return token!;
//   // }
// }
}
