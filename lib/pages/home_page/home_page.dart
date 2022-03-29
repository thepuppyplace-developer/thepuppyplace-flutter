import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../controllers/board/board_list_controller.dart';
import '../../models/Board.dart';
import '../../util/customs.dart';
import '../../util/png_list.dart';
import '../../widgets/cards/banner_card.dart';
import '../../widgets/cards/recent_board_card.dart';
import '../../widgets/tab_bars/search_tab_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardListController>(
      init: BoardListController(),
      builder: (BoardListController controller) {
        return controller.obx((List<Board>? boardList) => Scaffold(
          body: Scrollbar(
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
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index){
                    Board board = boardList![index];
                    return RecentBoardCard(board);
                  },
                      childCount: boardList!.length
                  ),
                ),
                if(controller.isLoading) const SliverLoading()
              ],
            ),
          ),
        ),
          onLoading: const LoadingView()
        );
      }
    );
  }
}
