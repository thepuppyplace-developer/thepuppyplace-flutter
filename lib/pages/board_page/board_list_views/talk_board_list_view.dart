import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../controllers/board/talk_board_list_controller.dart';
import '../../../models/Board.dart';
import '../../../util/customs.dart';
import '../../../widgets/cards/board_card.dart';
import '../../../widgets/loadings/refresh_loading.dart';

class TalkBoardListView extends StatefulWidget {
  const TalkBoardListView({Key? key}) : super(key: key);

  @override
  State<TalkBoardListView> createState() => _TalkBoardListViewState();
}

class _TalkBoardListViewState extends State<TalkBoardListView> {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) => Scrollbar(
    child: GetBuilder<TalkBoardListController>(
        autoRemove: false,
        init: TalkBoardListController(),
        builder: (TalkBoardListController controller) {
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
