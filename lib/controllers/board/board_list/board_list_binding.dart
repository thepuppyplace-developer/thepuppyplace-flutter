import 'package:get/get.dart';

import 'board_list_controller.dart';

class BoardListBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BoardListController());
  }
}