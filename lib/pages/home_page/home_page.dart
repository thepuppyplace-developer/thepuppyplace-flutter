import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/config/kakao_talk_config.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/home_views/best_board_list_view.dart';
import 'package:thepuppyplace_flutter/views/home_views/first_notice_view.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/category_button.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_button.dart';
import 'package:thepuppyplace_flutter/widgets/loadings/sliver_contents.dart';
import '../../controllers/board/best_board_list_controller.dart';
import '../../controllers/board/board_list_controller.dart';
import '../../models/Board.dart';
import '../../util/cached_network_image_list.dart';
import '../../widgets/cards/banner_card.dart';
import '../../widgets/cards/recent_board_card.dart';
import '../../widgets/loadings/refresh_contents.dart';
import '../../widgets/tab_bars/search_tab_bar.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homePage';
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
      autoRemove: false,
      init: BoardListController(),
      builder: (BoardListController controller) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
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
              bottom: SearchTabBar(
                  mediaHeight(context, 0.07),
                onTap: (){
                    Get.toNamed(SearchPage.routeName);
                },
              ),
            )
          ],
          body: Scrollbar(
            child: SmartRefresher(
              enablePullUp: controller.boardList.isEmpty ? false : true,
              controller: _refreshController,
              onRefresh: () async{
                BestBoardListController.to.refreshBoardList();
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
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: baseVerticalPadding(context),
                    sliver: const SliverToBoxAdapter(
                        child: BannerCard()),
                  ),
                  const FirstNoticeView(),
                  SliverToBoxAdapter(
                    child: CustomButton(
                      title: '카카오 로그인',
                      onPressed: () => KakaoTalkConfig.kakaoLogin(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.02)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('어떤 정보를 찾으시나요?', style: CustomTextStyle.w600(
                              context, scale: 0.02)),
                          Text('클릭해서 원하시는 컨텐츠를 둘러보세요',
                            style: CustomTextStyle.w400(
                                context, color: Colors.grey,
                                height: 2, scale: 0.015),)
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                    sliver: SliverGrid.count(
                      childAspectRatio: 7/6,
                        crossAxisCount: 3,
                        crossAxisSpacing: mediaWidth(context, 0.03),
                        mainAxisSpacing: mediaWidth(context, 0.03),
                        children: [
                          for(int index = 0; index < _categoryList.length; index++) CategoryButton(
                            category: _categoryList[index]['category'],
                            image: _categoryList[index]['image'],
                            currentIndex: index,
                          )
                        ]
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.02)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('베스트', style: CustomTextStyle.w600(
                              context, scale: 0.02)),
                          Text('지금 가장 인기있는 게시물을 확인해보세요',
                              style: CustomTextStyle.w400(
                                  context, color: Colors.grey,
                                  height: 2, scale: 0.015))
                        ],
                      ),
                    ),
                  ),
                  const BestBoardListView(),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.02)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('최신글', style: CustomTextStyle.w600(
                              context, scale: 0.02)),
                          Text('더퍼피플레이스의 최신글을 확인해보세요',
                            style: CustomTextStyle.w400(
                                context, color: Colors.grey,
                                height: 2, scale: 0.015),)
                        ],
                      ),
                    ),
                  ),
                  controller.obx((boardList) => SliverList(
                    delegate: SliverChildBuilderDelegate((context, index){
                      final Board board = boardList![index];
                      return RecentBoardCard(board);
                    },
                      childCount: boardList!.length
                    ),
                  ),
                      onEmpty: const SliverEmpty('등록되어 있는 글이 없습니다.', imageVisible: false),
                      onLoading: const SliverLoading(
                        animated: false,
                        message: '게시글을 불러오는 중입니다...',
                      )
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
