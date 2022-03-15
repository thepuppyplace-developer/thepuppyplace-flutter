import 'package:get/get.dart';

import 'board_controller.dart';

class BoardBinding extends Bindings{
  final int board_id;
  BoardBinding(this.board_id);

  @override
  void dependencies() {
    Get.lazyPut(() => BoardController(board_id));
  }
}