import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/search_board_list_controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/cards/search_board_card.dart';

import '../models/Board.dart';

class SearchBoardListView extends StatelessWidget {
  final String query;
  const SearchBoardListView(this.query, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchBoardListController>(
        init: SearchBoardListController(context, query),
        builder: (SearchBoardListController controller) {
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
                                text: "'$query'",
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
                      for(Board board in boardList) SearchBoardCard(board)
                    ]),
                  ),
                )
            ],
          ),
              onEmpty: const EmptyView(),
              onLoading: const LoadingView(),
              onError: (error) => CustomErrorView(error: error)
          );
        }
    );
  }
}
