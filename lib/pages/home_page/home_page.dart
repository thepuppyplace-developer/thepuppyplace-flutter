import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../controllers/board/board_list_controller.dart';
import '../../models/Board.dart';
import '../../util/customs.dart';
import '../../util/png_list.dart';
import '../../widgets/cards/banner_card.dart';
import '../../widgets/cards/recent_board_card.dart';
import '../../widgets/loadings/refresh_loading.dart';
import '../../widgets/tab_bars/search_tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardListController>(
        init: BoardListController(),
        builder: (BoardListController controller) {
          return controller.obx((List<Board>? boardList) =>
              Scrollbar(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        snap: true,
                        floating: true,
                        pinned: true,
                        centerTitle: false,
                        elevation: 0.1,
                        title: Image.asset(PngList.logo,
                          width: mediaWidth(context, 0.4),),
                        bottom: SearchTabBar(mediaHeight(context, 0.07),
                          padding: EdgeInsets.symmetric(
                              vertical: mediaHeight(context, 0.01)),),
                      )
                    ],
                    body: SmartRefresher(
                      enablePullUp: true,
                      controller: _refreshController,
                      header: CustomHeader(
                        builder: (context, RefreshStatus? status) {
                          switch (status) {
                            case RefreshStatus.completed: {
                              return Container();
                            }
                            default:
                              {
                                return const RefreshLoading();
                              }
                          }
                        },
                        readyToRefresh: () async{
                          controller.refreshBoardList().whenComplete((){
                            _refreshController.refreshCompleted();
                          });
                        },
                        endRefresh: () async {
                          _refreshController.loadComplete();
                        },
                      ),
                      footer: CustomFooter(
                        loadStyle: LoadStyle.ShowWhenLoading,
                        builder: (context, LoadStatus? status){
                          switch(status){
                            case LoadStatus.noMore: {
                              return const NoDataText();
                            }
                            default: {
                              return const RefreshLoading();
                            }
                          }
                        },
                        readyLoading: () async{
                          controller.limit.value += 1;
                          controller.getBoardList.whenComplete((){
                            _refreshController.loadComplete();
                          });
                        },
                        endLoading: () async{
                          if(controller.limit.value >= boardList!.length){
                            controller.getBoardList.whenComplete((){
                              _refreshController.loadNoData();
                            });
                          } else {
                            controller.getBoardList.whenComplete((){
                              _refreshController.loadComplete();
                            });
                          }
                        } ,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BannerCard(),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.02)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('최신글', style: CustomTextStyle.w600(
                                      context, scale: 0.024)),
                                  Text('더퍼피플레이스의 최신글을 확인해보세요',
                                    style: CustomTextStyle.w400(
                                        context, color: Colors.grey,
                                        height: 2),)
                                ],
                              ),
                            ),
                            Column(
                              children: List.generate(controller.limit.value <= boardList!.length
                                  ? controller.limit.value
                                  : boardList.length, (index) => RecentBoardCard(boardList[index]))
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              )
          );
        }
    );
  }
}
