import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../controllers/board/shopping_board_list_controller.dart';
import '../../../models/Board.dart';
import '../../../util/customs.dart';
import '../../../widgets/cards/board_card.dart';
import '../../../widgets/loadings/refresh_contents.dart';

class ShoppingBoardListView extends StatelessWidget {
  const ShoppingBoardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<ShoppingListController>(
      autoRemove: false,
      init: ShoppingListController(),
      builder: (ShoppingListController controller) {
        return Scrollbar(
          child: SmartRefresher(
              enablePullUp: controller.status.isSuccess,
              controller: controller.refreshController,
              onRefresh: () async{
                controller.getBoardList.whenComplete((){
                  controller.refreshController.refreshCompleted(
                      resetFooterState: true
                  );
                });
              },
              onLoading: () async{
                controller.page.value++;
                controller.getBoardList.whenComplete((){
                  controller.refreshController.loadComplete();
                });
              },
              header: CustomHeader(
                builder: (BuildContext context, RefreshStatus? status) => RefreshContents(status),
              ),
              footer: controller.status.isEmpty ? null : CustomFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                builder: (BuildContext context, LoadStatus? status) => LoadContents(status),
              ),
              child: controller.obx((List<Board>? boardList) => SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: boardList!.map((Board board) => BoardCard(board)).toList(),
                  )),
                  onLoading: const LoadingView(),
                  onEmpty: const EmptyView()
              )
          ),
        );
      }
  );
}
