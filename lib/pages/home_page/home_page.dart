import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/category_button.dart';
import '../../controllers/board/board_list_controller.dart';
import '../../models/Board.dart';
import '../../util/png_list.dart';
import '../../widgets/cards/banner_card.dart';
import '../../widgets/cards/recent_board_card.dart';
import '../../widgets/loadings/refresh_contents.dart';
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
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                centerTitle: false,
                elevation: 0.1,
                title: Image.asset(PngList.logo,
                  width: mediaWidth(context, 0.4),),
                bottom: SearchTabBar(mediaHeight(context, 0.07)),
              )
            ],
            body: Scrollbar(
              child: SmartRefresher(
                enablePullUp: controller.boardList.isEmpty ? false : true,
                controller: _refreshController,
                onRefresh: () async{
                  controller.refreshBoardList().whenComplete((){
                    _refreshController.refreshCompleted(resetFooterState: true);
                  });
                },
                onLoading: () async{
                  controller.page.value++;
                  controller.getBoardList().whenComplete((){
                    _refreshController.loadComplete();
                  });
                },
                header: CustomHeader(
                  builder: (BuildContext context, RefreshStatus? status) => RefreshContents(status),
                ),
                footer: controller.status.isEmpty ? null : CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus? status) => LoadContents(status),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BannerCard(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                        child: Text('어떤 정보를 찾으시나요?', style: CustomTextStyle.w600(context, scale: 0.02)),
                      ),
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
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                        child: controller.obx((List<Board>? boardList) => Column(
                            children: boardList!.map((board) => RecentBoardCard(board)).toList()
                        ),
                          onEmpty: Text('등록된 게시글이 없습니다.', style: CustomTextStyle.w500(context, color: CustomColors.hint), textAlign: TextAlign.center),
                          onLoading: const CupertinoActivityIndicator()
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
    );
  }
}
