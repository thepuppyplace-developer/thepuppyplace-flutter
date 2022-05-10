import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_board_list_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../widgets/tab_bars/search_tab_bar.dart';
import 'board_list_views/cafe_board_list_view.dart';
import 'board_list_views/ground_board_list_view.dart';
import 'board_list_views/hotel_board_list_view.dart';
import 'board_list_views/restaurant_board_list_view.dart';
import 'board_list_views/shopping_board_list_view.dart';
import 'board_list_views/talk_board_list_view.dart';

class BoardListPage extends StatefulWidget {
  static const String routeName = '/boardListPage';
  int currentIndex;
  final String? query;
  BoardListPage({required this.currentIndex, this.query, Key? key}) : super(key: key);

  @override
  State<BoardListPage> createState() => _BoardListPageState();
}

class _BoardListPageState extends State<BoardListPage> {
  final List<String> _categoryList = <String>[
    '카페', '음식점', '쇼핑몰', '호텔', '운동장', '수다방'
  ];

  final TextEditingController _queryController = TextEditingController();
  String? _query;

  List<Widget> _pageList(String? query) => [
    CafeBoardListView(query),
    RestaurantBoardListView(query),
    ShoppingBoardListView(query),
    HotelBoardListView(query),
    GroundBoardListView(query),
    TalkBoardListView(query),
  ];

  @override
  void initState() {
    super.initState();
    if(widget.query != null){
      _queryController.text = widget.query!;
      _query = widget.query;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.currentIndex,
      length: _pageList(widget.query).length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, index) => [
            SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                elevation: 0.1,
                title: InsertSearchTabBar(
                    mediaHeight(context, 0.07),
                    controller: _queryController,
                    onChanged: (_query){},
                    onSearchTap: (query){
                      Get.toNamed(SearchBoardListPage.routeName, arguments: query);
                    }
                ),
                bottom: TabBar(
                    onTap: (int index){
                      setState(() {
                        widget.currentIndex = index;
                      });
                    },
                    labelColor: Colors.black,
                    unselectedLabelColor: CustomColors.hint,
                    isScrollable: true,
                    unselectedLabelStyle: CustomTextStyle.w500(context),
                    labelStyle: CustomTextStyle.w600(context),
                    tabs: _categoryList.map((category) => Tab(
                        text: category)).toList()
                )
            ),
          ],
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: _pageList(_query),
          ),
        ),
      ),
    );
  }
}
