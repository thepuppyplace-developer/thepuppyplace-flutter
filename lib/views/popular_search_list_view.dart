import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/search/popular_keyword_list_controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/cards/popular_search_card.dart';

import '../models/Search.dart';
import '../pages/search_page/search_board_list_page.dart';

class PopularSearchListView extends StatelessWidget {
  const PopularSearchListView({Key? key}) : super(key: key);

  Future _deleteSearch(BuildContext context, PopularSearchListController controller, Search search) => controller.onSearchDelete(search).then((res) {
    switch(res.statusCode){
      case 200:
        return showToast('인기 검색어 ${search.search_text}가 삭제되었습니다.');
      case null:
        return network_check_message(context);
    }
  }).catchError((error) {
    unknown_message(context);
    throw Exception(error);
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopularSearchListController>(
      init: PopularSearchListController(context),
      builder: (PopularSearchListController controller) => controller.obx((popularSearchList) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(mediaWidth(context, 0.033)),
            sliver: SliverToBoxAdapter(
              child: Text('인기 검색어', style: CustomTextStyle.w600(context)),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index){
                final Search search = popularSearchList![index];
                return Row(
                  children: [
                    Text('${(index + 1)}. ', style: CustomTextStyle.w500(context)),
                    PopularSearchCard(search, (query){
                      Get.toNamed(SearchBoardListPage.routeName, arguments: query);
                    },
                      onDelete : (search) => showIndicator(_deleteSearch(context, controller, search)),
                    ),
                  ],
                );
              },
                childCount: popularSearchList!.length
              ),
            ),
          )
        ],
      ),
        onError: (error) => CustomErrorView(error: error),
        onLoading: const LoadingView(),
        onEmpty: const EmptyView(message: '인기 검색어가 없습니다.')
      ),
    );
  }
}
