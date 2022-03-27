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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              snap: true,
              floating: true,
              pinned: true,
              centerTitle: false,
              title: Image.asset(PngList.logo, height: mediaHeight(context, 0.05)),
              bottom: SearchTabBar(mediaHeight(context, 0.07), padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.013)),
              sliver: SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CarouselSlider.builder(
                      itemCount: 2,
                      options: CarouselOptions(
                          viewportFraction: 1,
                          height: 151
                      ),
                      itemBuilder: (context, index, index2){
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(JpegList.bannerList[index], fit: BoxFit.cover, width: mediaWidth(context, 1), height: 151));
                      },
                    ),
                    SmoothPageIndicator(
                      controller: _bannerController,
                      count: JpegList.bannerList.length,
                      effect: WormEffect(
                        dotWidth: mediaWidth(context, 0.02),
                        dotHeight: mediaWidth(context, 0.02),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('어떤 장소를 찾으시나요?', style: CustomTextStyle.w500(context, scale: 0.024),),
                    Text('클릭해서 원하시는 장소를 둘러보세요', style: CustomTextStyle.w400(context, color: Colors.grey, height: 2),)
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(mediaWidth(context, 0.033)),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: mediaWidth(context, 0.016)
                ),
                delegate: SliverChildBuilderDelegate((context, index){
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Image.asset(PngList.categoryList[index]),
                    onPressed: (){
                      Get.to(() => BoardListPage(index));
                    },
                  );
                },
                    childCount: PngList.categoryList.length
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.02)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('최신글', style: CustomTextStyle.w500(context, scale: 0.024),),
                    Text('더퍼피플레이스의 최신글을 확인해보세요', style: CustomTextStyle.w400(context, color: Colors.grey, height: 2),)
                  ],
                ),
              ),
            ),
            SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                sliver: GetBuilder<BoardListController>(
                    builder: (BoardListController controller) {
                      return controller.obx((List<Board>? boardList) => SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: mediaWidth(context, 0.026),
                          mainAxisExtent: mediaHeight(context, 0.3)
                        ),
                        delegate: SliverChildBuilderDelegate((context, index){
                          Board board = boardList![index];
                          return RecentBoardCard(board);
                        },
                            childCount: boardList!.length < 6 ? boardList.length : 6
                        ),
                      ),
                          onError: (error) => SliverError(error),
                          onLoading: const SliverLoading()
                      );
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}
