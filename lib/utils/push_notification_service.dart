// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:logger/logger.dart';
//
// // final _logger = Logger();
//
// class AppNotification {
//   static final AppNotification _notificationService =
//       AppNotification._internal();
//
//   factory AppNotification() {
//     return _notificationService;
//   }
//   AppNotification._internal();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static const _NOTIFICATION_ID = 12789;
//   void init({
//     required void Function(Map<String, dynamic>) handelMessage,
//   }) async {
//     await _initFireBase(handelMessage);
//
//     _initLocalNotification(handelMessage);
//     // _logger.d('init Notifications');
//   }
//
//   void showChatNotification(RemoteMessage message) async {
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       // Platform.isAndroid
//       //     ? 'com.dfa.flutterchatdemo'
//       //     : 'com.duytq.flutterchatdemo',
//       'Chat_Messageing_Id', 'Chat',
//       channelDescription: 'ّFor Messaging',
//       playSound: true,
//       enableVibration: true,
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//
//     //show notify
//     await flutterLocalNotificationsPlugin.show(
//       _NOTIFICATION_ID,
//       message.notification!.title.toString(),
//       message.notification!.body.toString(),
//       platformChannelSpecifics,
//       payload: json.encode(message.data),
//     );
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
//
//   Future<void> cancelNotifications() async {
//     await flutterLocalNotificationsPlugin.cancel(_NOTIFICATION_ID);
//   }
//
//   Future<void> _initFireBase(
//       void Function(Map<String, dynamic> type) handelMessage) async {
//     try {
//       FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//       await messaging.subscribeToTopic("all");
//
//       /// when from background come a notification
//       RemoteMessage? initialMessage = await messaging.getInitialMessage();
//       if (initialMessage != null) {
//         // _logger.d('>>>Firebase init Message availabel => $initialMessage');
//         //  RemoteMessage.fromMap(json.decode(notificationResponse.payload!));
//         handelMessage(initialMessage.data);
//         cancelAllNotifications();
//       }
//
//       ///forground message may have notification
//       FirebaseMessaging.onMessageOpenedApp
//           .listen((RemoteMessage remoteMessage) {
//         // _logger.d('>>>Firebase onMessageOpenedApp availabel => $remoteMessage');
//         handelMessage(remoteMessage.data);
//         cancelAllNotifications();
//       });
//
//       ///forground message may have notification
//       FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
//         // _logger.d('>>>Firebase onMessage availabel => $remoteMessage');
//
//         AppNotification().showChatNotification(remoteMessage);
//       });
//     } catch (_) {}
//   }
//
//   void _initLocalNotification(
//       void Function(Map<String, dynamic> type) handelMessage) {
//     ///Init Local notifications
//     ///
//     const initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     final initializationSettingsIOS = DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: false,
//       onDidReceiveLocalNotification: (id, title, body, payload) {
//         // _logger.d(
//         //     '>>>LocalNotification  `IOS` onDidReceiveLocalNotification availabel => id: $id , title: $title , body: $body , payload: $payload');
//
//         if (payload != null) {
//           // var type = json.decode(payload)['type'];
//           handelMessage(json.decode(payload));
//           cancelAllNotifications();
//         }
//       },
//     );
//
//     final initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (notificationResponse) {
//         // _logger.d(
//         //     '>>>LocalNotification `Plugin` onDidReceiveLocalNotification availabel => notificationResponse: $notificationResponse');
//
//         // RemoteMessage.fromMap(json.decode(notificationResponse.payload!));
//         if (notificationResponse.payload != null) {
//           // var type = json.decode(notificationResponse.payload!)['type'];
//           handelMessage(json.decode(notificationResponse.payload!));
//           cancelAllNotifications();
//         }
//       },
//       onDidReceiveBackgroundNotificationResponse: null,
//     );
//   }
// }
