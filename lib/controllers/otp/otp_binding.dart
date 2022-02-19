import 'package:get/get.dart';

import 'otp_controller.dart';

class OTPBinding extends Bindings{
  final String email;
  OTPBinding({required this.email});
  @override
  void dependencies() {
    Get.lazyPut(() => OTPController(email: email));
  }
}