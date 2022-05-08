import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/search/recommend_search_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_board_list_page.dart';
import 'package:thepuppyplace_flutter/views/popular_search_list_view.dart';
import 'package:thepuppyplace_flutter/views/recommend_search_list_view.dart';
import '../../util/common.dart';
import '../../views/rx_status_view.dart';
import '../../widgets/tab_bars/search_tab_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecommendSearchListController>(
        init: RecommendSearchListController(context),
        builder: (RecommendSearchListController controller) {
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, inner) => [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  pinned: true,
                  elevation: 0.5,
                  title: InsertSearchTabBar(mediaHeight(context, 0.07),
                    margin: EdgeInsets.zero,
                    hintText: '찾으시는 검색어를 입력하세요.',
                    onChanged: (query){
                      setState(() {
                        _query = query;
                      });
                      if(_query.isNotEmpty){
                        controller.getSearchList(_query);
                      }
                    },
                    onSearchTap: (query){
                      Get.toNamed(SearchBoardListPage.routeName, arguments: query);
                    },
                  ),
                ),
              ],
              body: Container(
                child: controller.obx((recommendSearchList) => const RecommendSearchListView(),
                    onEmpty: _query.isNotEmpty
                        ? EmptyView(message: "'$_query'에 대한 검색 결과가 없습니다.")
                        : const PopularSearchListView(),
                    onLoading: const LoadingView(),
                    onError: (error) => CustomErrorView(error: error)
                ),
              ),
            ),
          );
        }
    );
  }
}
