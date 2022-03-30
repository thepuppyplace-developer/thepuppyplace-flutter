import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../widgets/text_fields/out_line_text_field.dart';
import 'board_list_views/cafe_board_list_view.dart';
import 'board_list_views/ground_board_list_view.dart';
import 'board_list_views/hotel_board_list_view.dart';
import 'board_list_views/restaurant_board_list_view.dart';
import 'board_list_views/shopping_board_list_view.dart';
import 'board_list_views/talk_board_list_view.dart';

class BoardListPage extends StatefulWidget {
  int currentIndex;
  BoardListPage(this.currentIndex, {Key? key}) : super(key: key);

  @override
  State<BoardListPage> createState() => _BoardListPageState();
}

class _BoardListPageState extends State<BoardListPage> {
  final List<String> _categoryList = <String>[
    '카페', '음식점', '쇼핑몰', '호텔', '운동장', '수다방'
  ];

  final List<Widget> _pageList = const [
    CafeBoardListView(),
    RestaurantBoardListView(),
    ShoppingBoardListView(),
    HotelBoardListView(),
    GroundBoardListView(),
    TalkBoardListView(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.currentIndex,
      length: _pageList.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, index) => [
            SliverAppBar(
              snap: true,
              floating: true,
              pinned: true,
              elevation: 0.1,
              title: OutlineTextField(
                autofocus: false,
                controller: null,
                keyboardType: null,
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
            children: _pageList,
          ),
        ),
      ),
    );
  }
}
