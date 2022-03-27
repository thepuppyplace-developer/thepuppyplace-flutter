import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../controllers/board/cafe_board_list_controller.dart';
import '../../controllers/board/restaurant_board_list_controller.dart';
import '../../widgets/tab_bars/category_tab_bar.dart';
import '../../widgets/text_fields/out_line_text_field.dart';
import 'board_list_views/cafe_board_list_view.dart';
import 'board_list_views/ground_board_list_view.dart';
import 'board_list_views/hotel_board_list_view.dart';
import 'board_list_views/restaurant_board_list_view.dart';
import 'board_list_views/shopping_board_list_view.dart';

class BoardListPage extends StatefulWidget {
  final int currentIndex;
  const BoardListPage(this.currentIndex, {Key? key}) : super(key: key);

  @override
  State<BoardListPage> createState() => _BoardListPageState();
}

class _BoardListPageState extends State<BoardListPage> {
  int? currentIndex;
  final List<String> _categoryList = <String>[
    '카페', '음식점', '쇼핑몰', '호텔', '운동장'
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            floating: true,
            pinned: true,
            title: OutlineTextField(
              autofocus: false,
              controller: null,
              keyboardType: null,
            ),
            bottom: CategoryTabBar(mediaHeight(context, 0.07),
              currentIndex: currentIndex ?? widget.currentIndex,
              categoryList: _categoryList,
              onTap: (int index){
              setState(() {
                currentIndex = index;
              });
              },
            ),
          ),
          Builder(
            builder: (context){
              switch(currentIndex){
                case 0:
                  return const CafeBoardListView();
                case 1:
                  return const RestaurantBoardListView();
                case 2:
                  return const ShoppingBoardListView();
                case 3:
                  return const HotelBoardListView();
                case 4:
                  return const GroundBoardListView();
                default:
                  return const SliverToBoxAdapter();
              }
            },
          )
        ],
      ),
    );
  }
}
