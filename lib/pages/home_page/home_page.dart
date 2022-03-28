import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../controllers/board/board_list_controller.dart';
import '../../models/Board.dart';
import '../../util/customs.dart';
import '../../util/jpeg_list.dart';
import '../../util/png_list.dart';
import '../../widgets/cards/banner_card.dart';
import '../../widgets/cards/recent_board_card.dart';
import '../../widgets/tab_bars/search_tab_bar.dart';
import '../board_page/board_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _bannerController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _limit = 5;
  bool _isLoading = false;
  bool _refresh = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.offset > _scrollController.position.maxScrollExtent  && _scrollController.position.outOfRange){
        setState(() {
          _limit += 5;
          _isLoading = true;
        });
      }
      if(_scrollController.offset < -mediaHeight(context, 0.1)){
        print(_scrollController.position.pixels);
        setState(() {
          _refresh = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrimaryScrollController(
        controller: _scrollController,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                centerTitle: false,
                elevation: 0.1,
                title: Image.asset(PngList.logo, width: mediaWidth(context, 0.4),),
                bottom: SearchTabBar(mediaHeight(context, 0.07), padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),),
              ),
              if(_refresh) SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.03)),
                  child: const CupertinoActivityIndicator(),
                ),
              ),
              const BannerCard(),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.02)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('최신글', style: CustomTextStyle.w600(context, scale: 0.024)),
                      Text('더퍼피플레이스의 최신글을 확인해보세요', style: CustomTextStyle.w400(context, color: Colors.grey, height: 2),)
                    ],
                  ),
                ),
              ),
              GetBuilder<BoardListController>(
                builder: (BoardListController controller) => controller.obx((List<Board>? boardList) => SliverList(
                  delegate: SliverChildBuilderDelegate((context, index){
                    Board board = boardList![index];
                    return RecentBoardCard(board);
                  },
                    childCount: boardList!.length > _limit ? _limit : boardList.length
                  ),
                ),
                  onLoading: const SliverLoading(),
                  onError: (error) => SliverError(error)
                ),
              ),
              if(_isLoading) SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(bottom: mediaWidth(context, 0.033)),
                    child: const CupertinoActivityIndicator()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
