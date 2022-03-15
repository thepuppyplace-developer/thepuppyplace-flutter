import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../controllers/board/board/board_controller.dart';
import '../../controllers/board/board_list/board_list_controller.dart';
import '../../models/Board.dart';
import '../../util/icon_list.dart';
import '../../util/jpeg_list.dart';
import '../../widgets/list_tile/board_list_tile.dart';
import '../../widgets/tab_bars/location_tab_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              snap: true,
              floating: true,
              pinned: true,
              title: const Text('홈'),
              actions: [
                CupertinoButton(
                  child: const Icon(Icons.search, color: Colors.black),
                  onPressed: (){},
                )
              ],
              bottom: LocationTabBar(mediaHeight(context, 0.07)),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: mediaHeight(context, 0.05)),
              sliver: SliverToBoxAdapter(
                child: CarouselSlider.builder(
                  itemCount: 2,
                  options: CarouselOptions(
                      viewportFraction: 1,
                      height: mediaHeight(context, 0.2)
                  ),
                  itemBuilder: (context, index, index2){
                    return Image.asset(JpegList.bannerList[index], fit: BoxFit.fitWidth, width: mediaWidth(context, 1));
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.044)),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4
                ),
                delegate: SliverChildBuilderDelegate((context, index) => CupertinoButton(
                  child: Column(
                    children: [
                      Icon(IconList.home[index]['icon'], color: Colors.black),
                      Text(IconList.home[index]['text'], style: CustomTextStyle.w500(context, height: 2))
                    ],
                  ),
                  onPressed: (){

                  },
                ),
                    childCount: IconList.home.length),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.03)),
              sliver: SliverToBoxAdapter(
                child: Text('최근 게시물', style: CustomTextStyle.w500(context, scale: 0.02)),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: mediaHeight(context, 0.1),
              delegate: SliverChildBuilderDelegate((context, index){
                return GetBuilder<BoardListController>(
                  builder: (BoardListController controller){
                    return controller.obx((List<Board>? boardList){
                      Board board = boardList![index];
                      return BoardListTile(board: board);
                    },
                      onLoading: Container()
                    );
                  },
                );
              },
                  childCount: 10
              ),
            )
          ],
        ),
      ),
    );
  }
}
