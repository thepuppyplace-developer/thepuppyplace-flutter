import 'package:get/get.dart';

import 'board_controller.dart';

class BoardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BoardController());
  }
}