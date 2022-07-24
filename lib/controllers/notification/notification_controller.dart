import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/notification/notification_log_list_controller.dart';
import '../../config/config.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../util/common.dart';

class NotificationController extends GetxController with Config{

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  //Android notification 세팅
  final IOSInitializationSettings _iosSettings = const IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  AndroidNotificationDetails get _androidDetails => AndroidNotificationDetails( //Android notification 상세 세팅
    channelId,
    channelName,
    channelDescription: channelDescription,
    priority: Priority.high,
    importance: Importance.max,
    largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    color: CustomColors.main,
  );

  IOSNotificationDetails get _iosDetails => const IOSNotificationDetails( //IOS notification 상세 세팅
    //IOS notification 상세 세팅
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  NotificationDetails get _notificationDetails => NotificationDetails(
    //Android 상세 세팅
      android: _androidDetails,
      iOS: _iosDetails
  );

  //Android, IOS 상세를 합친 함수
  InitializationSettings get _settings => InitializationSettings(
      android: _androidSettings,
      iOS: _iosSettings
  );
  //  초기 notification 세팅

  @override
  void onInit() {
    _fcm.requestPermission(
      //firebase cloud message 알림 허용여부
        alert: true,
        badge: true,
        sound: true
    );

    _fcm.setForegroundNotificationPresentationOptions(
      //firebase cloud message 앱 실행시에 허용여부
        alert: true,
        badge: true,
        sound: true
    );

    FirebaseMessaging.onMessageOpenedApp.listen(_onNotification);

    FirebaseMessaging.onMessage.listen(_onForegroundNotification);

    super.onInit();
  }

  void _onNotification(RemoteMessage message){
    ///알림 클릭시 동작
    try{
      String action = message.data['action'];
      String actionType = message.data['action_type'];
      int boardId = int.parse(message.data['board_id']);
      NotificationLogListController.to.refreshLogList;
      switch (actionType) {
        case 'web':
          openURL(url: action, inApp: true);
          break;
        default:
          switch(action){
            default: Get.toNamed(action, arguments: boardId);
          }
      }
    } catch(error){
      throw Exception(error);
    }
  }

  void _onForegroundNotification(RemoteMessage message){
    try{
      _localNotifications.initialize(
          _settings,
          onSelectNotification: (String? payload){
            _onNotification(message);
          }
      );
    } catch(error){
      throw Exception(error);
    }
  }


// Future insertReservedNotification({
//   required String title,
//   required String body,
//   required String? payload,
//   required DateTime reservedAt,
// }) async{
//   //알림 예약 함수
//   final NotificationMessage? notification = await _sql.reserveNotification(title: title, body: body, payload: payload, reservedAt: reservedAt);
//   if(notification != null){
//     _repo.reserveNotification(_notificationDetails, notification);
//   }
// }
}