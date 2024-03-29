import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../controllers/board/ground_board_list_controller.dart';
import '../../../models/Board.dart';
import '../../../util/common.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';
import '../../../widgets/buttons/order_button.dart';
import '../../../widgets/cards/board_card.dart';
import '../../../widgets/loadings/refresh_contents.dart';

class GroundBoardListView extends StatefulWidget {
  final String? query;
  const GroundBoardListView(this.query, {Key? key}) : super(key: key);

  @override
  State<GroundBoardListView> createState() => _GroundBoardListViewState();
}

class _GroundBoardListViewState extends State<GroundBoardListView> {
  @override
  Widget build(BuildContext context) => GetBuilder<GroundBoardListController>(
      autoRemove: false,
      init: GroundBoardListController(widget.query),
      builder: (GroundBoardListController controller) {
        return Scrollbar(
          child: SmartRefresher(
              enablePullUp: controller.status.isSuccess,
              controller: controller.refreshController,
              onRefresh: () async{
                controller.page.value = 0;
                controller.refreshBoardList().whenComplete((){
                  controller.refreshController.refreshCompleted(
                      resetFooterState: true
                  );
                });
              },
              onLoading: () async{
                controller.page.value++;
                controller.getBoardList().whenComplete((){
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
                    children: [
                      OrderButton(
                        order: orderText(controller.order.value),
                        onSelected: (String order){
                          controller.page.value = 0;
                          controller.order.value = order;
                          controller.refreshBoardList();
                        },
                      ),
                      for(Board board in boardList!) BoardCard(board)
                    ],
                  )),
                  onLoading: const LoadingView(),
                  onEmpty: const EmptyView()
              )
          ),
        );
      }
  );
}
