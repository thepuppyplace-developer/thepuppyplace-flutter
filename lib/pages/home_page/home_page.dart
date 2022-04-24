import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/category_button.dart';
import '../../controllers/board/board_list_controller.dart';
import '../../models/Board.dart';
import '../../util/cached_network_image_list.dart';
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
      'image': CachedNetworkImageList.cafe
    },
    {
      'category': '음식점',
      'image': CachedNetworkImageList.restaurant
    },
    {
      'category': '쇼핑몰',
      'image': CachedNetworkImageList.shopping
    },
    {
      'category': '호텔',
      'image': CachedNetworkImageList.hotel
    },
    {
      'category': '운동장',
      'image': CachedNetworkImageList.ground
    },
    {
      'category': '수다방',
      'image': CachedNetworkImageList.cafe
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
                title: RichText(
                  text: TextSpan(
                    style: CustomTextStyle.w500(context, scale: 0.025),
                    children: [
                      const TextSpan(
                        text: 'the '
                      ),
                      TextSpan(
                        text: 'puppy place',
                        style: CustomTextStyle.w900(context, scale: 0.025)
                      )
                    ]
                  ),
                ),
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
                        margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.02)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('어떤 정보를 찾으시나요?', style: CustomTextStyle.w600(
                                context, scale: 0.02)),
                            Text('클릭해서 원하시는 컨텐츠를 둘러보세요',
                              style: CustomTextStyle.w400(
                                  context, color: Colors.grey,
                                  height: 2),)
                          ],
                        ),
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
                            Text('베스트', style: CustomTextStyle.w600(
                                context, scale: 0.02)),
                            Text('지금 가장 인기있는 게시물을 확인해보세요',
                              style: CustomTextStyle.w400(
                                  context, color: Colors.grey,
                                  height: 2),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.02)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('최신글', style: CustomTextStyle.w600(
                                context, scale: 0.02)),
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
