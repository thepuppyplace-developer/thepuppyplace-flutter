import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/search_board_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_list_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_text_button.dart';
import 'package:thepuppyplace_flutter/widgets/cards/search_board_card.dart';

import '../models/Board.dart';

class SearchBoardListView extends GetView<SearchBoardListController> {
  final String query;

  const SearchBoardListView(this.query, {Key? key}) : super(key: key);

  int pageIndex(String category){
    switch(category){
      case '카페': return 0;
      case '음식점': return 1;
      case '쇼핑몰': return 2;
      case '호텔': return 3;
      case '운동장': return 4;
      case '수다방': return 5;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return controller.obx((searchBoardList) => CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          sliver: SliverToBoxAdapter(
              child: RichText(
                text: TextSpan(
                    style: CustomTextStyle.w500(context, color: Colors.grey),
                    children: [
                      TextSpan(
                          text: "'${controller.queryString.value}'",
                          style: CustomTextStyle.w600(context, color: Colors.black)
                      ),
                      TextSpan(
                          text: '(으)로 검색한 ${controller.searchListLength()}건의 검색결과'),
                    ]
                ),
              )
          ),
        ),
        for(List<Board> boardList in searchBoardList!.values)
          if(boardList.isNotEmpty) SliverPadding(
            padding: EdgeInsets.all(mediaWidth(context, 0.033)),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: boardList.first.category, style: CustomTextStyle.w600(context, scale: 0.02)),
                          TextSpan(text: ' ${boardList.length}건', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.main)),
                        ]
                    ),
                  ),
                ),
                for(Board board in boardList.take(3)) SearchBoardCard(board),
                if(boardList.length > 3) CustomTextButton('더보기', (){
                  Get.to(() => BoardListPage(currentIndex: pageIndex(boardList.first.category), query: query));
                })
              ]),
            ),
          )
      ],
    ),
        onEmpty: EmptyView(message: "'${controller.queryString.value}'에 대한 검색결과가 없습니다."),
        onLoading: const LoadingView(),
        onError: (error) => CustomErrorView(error: error)
    );
  }
}
