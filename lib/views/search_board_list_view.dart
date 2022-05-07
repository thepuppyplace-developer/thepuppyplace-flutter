import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/search_board_controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/rx_status_view.dart';

class SearchBoardListView extends GetView<SearchBoardListController> {
  final String query;
  const SearchBoardListView(this.query, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx((boardList) => CustomScrollView(
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
                          text: '(으)로 검색한 ${controller.boardList.length}건의 검색결과'),
                    ]
                ),
              )
          ),
        ),
      ],
    ),
        onEmpty: const EmptyView(),
        onLoading: const LoadingView(),
        onError: (error) => CustomErrorView(error: error)
    );
  }
}
