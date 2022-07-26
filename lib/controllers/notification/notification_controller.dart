import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/notification/notification_log_list_controller.dart';
import '../../config/config.dart';
import '../../util/common.dart';

class NotificationController extends GetxController with Config {

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher');

  //Android notification 세팅
  final IOSInitializationSettings _iosSettings = const IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  AndroidNotificationDetails get _androidDetails =>
      AndroidNotificationDetails( //Android notification 상세 세팅
        channelId,
        channelName,
        channelDescription: channelDescription,
        priority: Priority.high,
        importance: Importance.max,
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: CustomColors.main,
      );

  IOSNotificationDetails get _iosDetails =>
      const IOSNotificationDetails( //IOS notification 상세 세팅
        //IOS notification 상세 세팅
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

  NotificationDetails get _notificationDetails =>
      NotificationDetails(
        //Android 상세 세팅
          android: _androidDetails,
          iOS: _iosDetails
      );

  //Android, IOS 상세를 합친 함수
  InitializationSettings get _settings =>
      InitializationSettings(
          android: _androidSettings,
          iOS: _iosSettings
      );

  //  초기 notification 세팅

  @override
  void onInit() async{
    _fcm.setForegroundNotificationPresentationOptions(
      //firebase cloud message 앱 실행시에 허용여부
        alert: true,
        badge: true,
        sound: true
    );

    final NotificationSettings _permission = await _fcm.requestPermission(
      //firebase cloud message 알림 허용여부
        alert: true,
        badge: true,
        sound: true
    );

    if(_permission.authorizationStatus == AuthorizationStatus.authorized){

      if(Platform.isAndroid) _fcm.getInitialMessage().then(_onNotification);

      FirebaseMessaging.onMessageOpenedApp.listen(_onNotification);

      FirebaseMessaging.onMessage.listen(_onForegroundNotification);
    }
    super.onInit();
  }

  void _onNotification(RemoteMessage? message) {
    ///알림 클릭시 동작
    try {
      if(message != null){
        String action = message.data['action'];
        String actionType = message.data['action_type'];
        int board_id = int.parse(message.data['board_id']);
        switch (actionType) {
          case 'web':
            openURL(url: action, inApp: true);
            break;
          default:
            switch (action) {
              default:
                Get.toNamed(action, arguments: RxInt(board_id));
            }
        }
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  void _onForegroundNotification(RemoteMessage message) {
    try {
      if (Platform.isAndroid) {
        _localNotifications.show(
          message.hashCode, message.notification?.title,
          message.notification?.body, _notificationDetails);
      }
      _localNotifications.initialize(
          _settings,
          onSelectNotification: (String? payload) {
            NotificationLogListController.to.refreshLogList;
            _onNotification(message);
          }
      );
    } catch (error) {
      throw Exception(error);
    }
  }
}