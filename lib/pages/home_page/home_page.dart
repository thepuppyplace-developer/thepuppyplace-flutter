import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/category_button.dart';
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
  final List<Map<String, dynamic>> _categoryList = <Map<String, dynamic>>[
    {
      'category': '카페',
      'image': PngList.cafe
    },
    {
      'category': '음식점',
      'image': PngList.restaurant
    },
    {
      'category': '쇼핑몰',
      'image': PngList.shopping_mall
    },
    {
      'category': '호텔',
      'image': PngList.hotel
    },
    {
      'category': '운동장',
      'image': PngList.ground
    },
    {
      'category': '수다방',
      'image': PngList.cafe
    },
  ];

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
                        readyToRefresh: () async{
                          controller.refreshBoardList().whenComplete(() async{
                            if(controller.status.isEmpty){
                              _refreshController.refreshFailed();
                            } else {
                              _refreshController.refreshCompleted(resetFooterState: true);
                            }
                          });
                        },
                      ),
                      footer: controller.status.isEmpty ? null : CustomFooter(
                        loadStyle: LoadStyle.ShowWhenLoading,
                        readyLoading: () async{
                          Future.delayed(const Duration(seconds: 1), (){
                            controller.limit.value += 5;
                            controller.getBoardList.whenComplete((){
                              if(controller.limit.value >= boardList!.length){
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BannerCard(),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                              child: Wrap(
                                children: [
                                  for(int index = 0; index < _categoryList.length; index++) CategoryButton(
                                    category: _categoryList[index]['category'],
                                    image: _categoryList[index]['image'],
                                    currentIndex: index,
                                  )
                                ],
                              ),
                            ),
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
              ),
            onLoading: const LoadingView()
          );
        },
    );
  }
}
