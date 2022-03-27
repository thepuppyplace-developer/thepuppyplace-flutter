import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/board/board_controller.dart';
import '../../models/Board.dart';

class BoardDetailsPage extends GetWidget<BoardController> {
  const BoardDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx((Board? board) => CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(board!.title),
          ),
          SliverToBoxAdapter(
            child: Text('${board.likeList!.length}'),
          )
        ],
      )),
    );
  }
}
