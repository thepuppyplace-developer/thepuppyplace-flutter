import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../../controllers/board/ground_board_list_controller.dart';
import '../../../models/Board.dart';
import '../../../util/customs.dart';
import '../../../widgets/cards/board_card.dart';
import '../../../widgets/loadings/refresh_loading.dart';

class GroundBoardListView extends StatefulWidget {
  const GroundBoardListView({Key? key}) : super(key: key);

  @override
  State<GroundBoardListView> createState() => _GroundBoardListViewState();
}

class _GroundBoardListViewState extends State<GroundBoardListView> {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) => Scrollbar(
    child: GetBuilder<GroundBoardListController>(
        autoRemove: false,
        init: GroundBoardListController(),
        builder: (GroundBoardListController controller) {
          return SmartRefresher(
              enablePullUp: controller.status.isSuccess ? true : false,
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
                builder: (BuildContext context, RefreshStatus? status){
                  switch(status){
                    case RefreshStatus.completed: {
                      return const SuccessText();
                    }
                    case RefreshStatus.failed: {
                      return const EmptyText();
                    }
                    default: {
                      return const RefreshLoading();
                    }
                  }
                },
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
                builder: (BuildContext context, LoadStatus? status){
                  switch(status){
                    case LoadStatus.noMore: {
                      return const NoDataText();
                    }
                    default: {
                      return const RefreshLoading();
                    }
                  }
                },
              ),
              child: controller.obx((List<Board>? boardList) => SingleChildScrollView(
                child: Column(
                  children: List.generate(controller.limit.value <= boardList!.length
                      ? controller.limit.value
                      : boardList.length, (index) => BoardCard(boardList[index])),
                ),
              ),
                  onLoading: const LoadingView(),
                  onEmpty: const EmptyView()
              )
          );
        }
    ),
  );
}
