import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/controllers/board/best_board_list_controller.dart';
import 'package:thepuppyplace_flutter/widgets/cards/best_board_card.dart';
import 'package:thepuppyplace_flutter/widgets/loadings/sliver_contents.dart';

import '../../util/common.dart';

class BestBoardListView extends StatelessWidget {
  const BestBoardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BestBoardListController>(
        init: BestBoardListController(),
        builder: (BestBoardListController controller) => controller.obx((boardList) => SliverToBoxAdapter(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider.builder(
                itemCount: boardList!.length ~/ 3,
                options: CarouselOptions(
                    height: mediaHeight(context, 0.5),
                    disableCenter: true,
                    enableInfiniteScroll: false
                ),
                itemBuilder: (context, index, index2){
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: boardList.map((board) => BestBoardCard(board)).toList()
                          .sublist(index * 3, index * 3 + 3)
                  );
                },
              ),
              AnimatedSmoothIndicator(
                activeIndex: controller.pageIndex.value,
                count: boardList.length ~/ 3,
                effect: WormEffect(
                    activeDotColor: CustomColors.main,
                    dotColor: CustomColors.hint,
                    dotHeight: mediaHeight(context, 0.01),
                    dotWidth: mediaHeight(context, 0.01)
                ),
              )
            ],
          ),
        ),
            onError: (error) => SliverEmpty(error ?? '알 수 없는 오류'),
            onLoading: const SliverLoading(),
            onEmpty: const SliverEmpty('베스트 게시글이 없습니다.')
        )
    );
  }
}
