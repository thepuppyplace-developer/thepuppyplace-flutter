import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/search/recommend_search_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_board_list_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/cards/popular_search_card.dart';

import '../models/Search.dart';

class RecommendSearchListView extends GetView<RecommendSearchListController> {
  const RecommendSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => controller.obx((recommendSearchList) => CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index){
          final Search search = recommendSearchList![index];
          return Container(
              padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
              child: PopularSearchCard(search, (query){
                Get.toNamed(SearchBoardListPage.routeName, arguments: query);
              }, onDelete: null

              ));
        },
          childCount: recommendSearchList!.length
        ),
      )
    ],
  ));
}
