import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/board/my_board_list_controller.dart';
import '../../controllers/board/my_like_board_list_controller.dart';
import '../../util/common.dart';
import '../../widgets/cards/board_card.dart';
import '../../widgets/loadings/sliver_contents.dart';

class MyLikeBoardListPage extends StatelessWidget {
  const MyLikeBoardListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyLikeBoardListController>(
      init: MyLikeBoardListController(context),
      builder: (MyLikeBoardListController controller) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, inner) => [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                elevation: 0.5,
                title: Text('내가 좋아한 게시물', style: CustomTextStyle.w600(context, scale: 0.02)),
              )
            ],
            body: CustomScrollView(
              slivers: [
                controller.obx((boardList) => SliverList(
                    delegate: SliverChildBuilderDelegate((context, index){
                      final board = boardList![index];
                      return BoardCard(board.board);
                    },
                      childCount: boardList!.length
                    ),
                ),
                  onLoading: const SliverLoading(),
                  onEmpty: const SliverEmpty('등록한 게시글이 없습니다.')
                )
              ],
            ),
          )
        );
      }
    );
  }
}
