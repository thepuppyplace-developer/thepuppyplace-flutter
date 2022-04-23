import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/board/my_board_list_controller.dart';
import '../../util/common.dart';
import '../../widgets/cards/board_card.dart';
import '../../widgets/loadings/sliver_contents.dart';

class MyBoardListPage extends StatelessWidget {
  const MyBoardListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyBoardListController>(
      init: MyBoardListController(),
      builder: (MyBoardListController controller) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, inner) => [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                elevation: 0.5,
                title: Text('내가 쓴 게시물', style: CustomTextStyle.w600(context, scale: 0.02)),
              )
            ],
            body: CustomScrollView(
              slivers: [
                controller.obx((boardList) => SliverList(
                    delegate: SliverChildBuilderDelegate((context, index){
                      final board = boardList![index];
                      return BoardCard(board);
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
