import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../../controllers/board/restaurant_board_list_controller.dart';
import '../../../models/Board.dart';
import '../../../util/customs.dart';
import '../../../widgets/cards/board_card.dart';
import '../../../widgets/loadings/refresh_contents.dart';

class RestaurantBoardListView extends StatefulWidget {
  const RestaurantBoardListView({Key? key}) : super(key: key);

  @override
  State<RestaurantBoardListView> createState() => _RestaurantBoardListViewState();
}

class _RestaurantBoardListViewState extends State<RestaurantBoardListView> {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) => Scrollbar(
    child: GetBuilder<RestaurantBoardListController>(
        autoRemove: false,
        init: RestaurantBoardListController(),
        builder: (RestaurantBoardListController controller) {
          return SmartRefresher(
              enablePullUp: true,
              controller: _refreshController,
              header: CustomHeader(
                readyToRefresh: () async{
                  controller.refreshBoardList().whenComplete(() async{
                    if(controller.status.isEmpty){
                      _refreshController.refreshFailed();
                    } else {
                      _refreshController.refreshCompleted(resetFooterState: true);
                    }
                  });
                },
                builder: (BuildContext context, RefreshStatus? status) => RefreshContents(status),
              ),
              footer: controller.status.isEmpty ? null : CustomFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                readyLoading: () async{
                  Future.delayed(const Duration(seconds: 1), (){
                    controller.limit.value += 5;
                    controller.getBoardList.whenComplete((){
                      if(controller.limit.value >= controller.boardList.length){
                        _refreshController.loadNoData();
                      } else {
                        _refreshController.loadComplete();
                      }
                    });
                  });
                },
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
          );
        }
    ),
  );
}
