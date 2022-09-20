import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/search_board_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_list_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_text_button.dart';
import 'package:thepuppyplace_flutter/widgets/cards/search_board_card.dart';

import '../models/Board.dart';

class SearchBoardListView extends GetView<SearchBoardListController> {
  final String query;

  const SearchBoardListView(this.query, {Key? key}) : super(key: key);

  int pageIndex(String category){
    switch(category){
      case '카페': return 0;
      case '음식점': return 1;
      case '쇼핑몰': return 2;
      case '호텔': return 3;
      case '운동장': return 4;
      case '수다방': return 5;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          text: "'${controller.query.value}'",
                          style: CustomTextStyle.w600(context, color: Colors.black)
                      ),
                      TextSpan(
                          text: '(으)로 검색한 ${controller.searchListLength}건의 검색결과'),
                    ]
                ),
                overflow: TextOverflow.ellipsis,
              )
          ),
        ),
        if(controller.cafeList.isNotEmpty) SliverPadding(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: controller.cafeList.first.category, style: CustomTextStyle.w600(context, scale: 0.02)),
                        TextSpan(text: ' ${controller.cafeList.length}건', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.main)),
                      ]
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for(Board board in controller.cafeList.take(3)) SearchBoardCard(board),
              if(controller.cafeList.length > 3) CustomTextButton('더보기', (){
                Get.to(() => BoardListPage(query: query, currentIndex: pageIndex(controller.cafeList.first.category)));
              })
            ]),
          ),
        ),
        if(controller.foodList.isNotEmpty) SliverPadding(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: controller.foodList.first.category, style: CustomTextStyle.w600(context, scale: 0.02)),
                        TextSpan(text: ' ${controller.foodList.length}건', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.main)),
                      ]
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for(Board board in controller.foodList.take(3)) SearchBoardCard(board),
              if(controller.foodList.length > 3) CustomTextButton('더보기', (){
                Get.to(() => BoardListPage(query: query, currentIndex: pageIndex(controller.foodList.first.category)));
              })
            ]),
          ),
        ),
        if(controller.shoppingList.isNotEmpty) SliverPadding(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: controller.shoppingList.first.category, style: CustomTextStyle.w600(context, scale: 0.02)),
                        TextSpan(text: ' ${controller.shoppingList.length}건', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.main)),
                      ]
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for(Board board in controller.shoppingList.take(3)) SearchBoardCard(board),
              if(controller.shoppingList.length > 3) CustomTextButton('더보기', (){
                Get.to(() => BoardListPage(query: query, currentIndex: pageIndex(controller.shoppingList.first.category)));
              })
            ]),
          ),
        ),
        if(controller.hotelList.isNotEmpty) SliverPadding(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: controller.hotelList.first.category, style: CustomTextStyle.w600(context, scale: 0.02)),
                        TextSpan(text: ' ${controller.hotelList.length}건', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.main)),
                      ]
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for(Board board in controller.hotelList.take(3)) SearchBoardCard(board),
              if(controller.hotelList.length > 3) CustomTextButton('더보기', (){
                Get.to(() => BoardListPage(query: query, currentIndex: pageIndex(controller.hotelList.first.category)));
              })
            ]),
          ),
        ),
        if(controller.groundList.isNotEmpty) SliverPadding(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: controller.groundList.first.category, style: CustomTextStyle.w600(context, scale: 0.02)),
                        TextSpan(text: ' ${controller.groundList.length}건', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.main)),
                      ]
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for(Board board in controller.groundList.take(3)) SearchBoardCard(board),
              if(controller.groundList.length > 3) CustomTextButton('더보기', (){
                Get.to(() => BoardListPage(query: query, currentIndex: pageIndex(controller.groundList.first.category)));
              })
            ]),
          ),
        ),
        if(controller.talkList.isNotEmpty) SliverPadding(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: controller.talkList.first.category, style: CustomTextStyle.w600(context, scale: 0.02)),
                        TextSpan(text: ' ${controller.talkList.length}건', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.main)),
                      ]
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for(Board board in controller.talkList.take(3)) SearchBoardCard(board),
              if(controller.talkList.length > 3) CustomTextButton('더보기', (){
                Get.to(() => BoardListPage(query: query, currentIndex: pageIndex(controller.talkList.first.category)));
              })
            ]),
          ),
        )
      ],
    ),
        onEmpty: EmptyView(message: "'${controller.query.value}'에 대한 검색결과가 없습니다."),
        onLoading: const LoadingView(),
        onError: (error) => CustomErrorView(error: error)
    );
  }
}
