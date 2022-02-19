import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'notification_repository.dart';

class NotificationController extends GetxController{
  static NotificationController get to => Get.put(NotificationController());
  final NotificationRepository _repo = NotificationRepository();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final Rx<String?> _fcmToken = Rx(null);
  String? get fcmToken => _fcmToken.value;

  @override
  void onInit() async{
    super.onInit();
    _fcmToken.value = await _firebaseMessaging.getToken();
  }
}