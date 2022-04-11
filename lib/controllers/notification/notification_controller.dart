import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../repositories/notification_repository.dart';

class NotificationController extends GetxController{
  static NotificationController get to => Get.put(NotificationController());
  final NotificationRepository _repo = NotificationRepository();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
}