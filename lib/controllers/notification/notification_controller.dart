import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../config/config.dart';
import '../../util/common.dart';

class NotificationController extends GetxController with Config{

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings _iosSettings = const IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  late AndroidNotificationDetails _androidDetails;
  late IOSNotificationDetails _iosDetails;
  late NotificationDetails _notificationDetails;
  late InitializationSettings _settings;

  late NotificationSettings _notificationSettings;

  @override
  void onInit() async {
    _notificationSettings = await _fcm.requestPermission(
      alert: true,
      sound: true,
      badge: true
    );

    if(_notificationSettings.authorizationStatus == AuthorizationStatus.authorized || _notificationSettings.authorizationStatus == AuthorizationStatus.provisional){
      _androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        priority: Priority.high,
        importance: Importance.max,
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: CustomColors.main,
      );

      _settings = InitializationSettings(
          android: _androidSettings,
          iOS: _iosSettings
      );

      _iosDetails = const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      _notificationDetails = NotificationDetails(
          android: _androidDetails,
          iOS: _iosDetails
      );

      _localNotifications.initialize(
          _settings,
          onSelectNotification: (String? payload){
            print(payload);
            if(payload != null){
              final data = jsonDecode(payload);
              String action = data['action'];
              String actionType = data['action_type'];
              int board_id = int.parse(data['board_id']);
              switch (actionType) {
                case 'web':
                  {
                    openURL(url: action, inApp: false);
                    break;
                  }
                default:
                  Get.toNamed(action, preventDuplicates: false, arguments: board_id);
              }
            }
          }
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        if (notification != null) {
          _localNotifications.show(
              notification.hashCode,
              notification.title,
              notification.body,
              _notificationDetails,
              payload: jsonEncode(message.data)
          );
        }
      });

      _fcm.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true
      );

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        String action = message.data['action'];
        String actionType = message.data['action_type'];
        int board_id = int.parse(message.data['board_id']);
        switch (actionType) {
          case 'web':
            {
              openURL(url: action, inApp: false);
              break;
            }
          default:
            Get.toNamed(action, preventDuplicates: false, arguments: board_id);
        }
      });
    }
  }
}