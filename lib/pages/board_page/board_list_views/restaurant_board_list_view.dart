import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/board/cafe_board_list_controller.dart';
import '../../../controllers/board/restaurant_board_list_controller.dart';
import '../../../models/Board.dart';
import '../../../util/customs.dart';
import '../../../widgets/cards/board_card.dart';

class RestaurantBoardListView extends StatelessWidget {
  const RestaurantBoardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<RestaurantBoardListController>(
    init: RestaurantBoardListController(),
    builder: (RestaurantBoardListController controller) {
      return controller.obx((List<Board>? boardList) => SliverList(
        delegate: SliverChildBuilderDelegate((context, index){
          Board board = boardList![index];
          return BoardCard(board);
        },
            childCount: boardList!.length
        ),
      ),
          onLoading: const SliverLoading(),
          onEmpty: _onEmpty()
      );
    }
  );

  Widget _onEmpty() => SliverFillRemaining(
    child: Container(
      alignment: Alignment.center,
      child: Text('빔'),
    ),
  );
}
