import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/search/popular_keyword_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_list_page.dart';
import 'package:thepuppyplace_flutter/util/customs.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_text_button.dart';
import 'package:thepuppyplace_flutter/widgets/tab_bars/search_condition_bar.dart';
import '../../controllers/board/search_board_controller.dart';
import '../../models/Board.dart';
import '../../models/Search.dart';
import '../../util/common.dart';
import '../../widgets/cards/search_board_card.dart';
import '../../widgets/cards/popular_search_card.dart';
import '../../widgets/loadings/sliver_contents.dart';
import '../../widgets/tab_bars/search_tab_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchBoardListController>(
        init: SearchBoardListController(context),
        builder: (SearchBoardListController controller) {
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
                    controller: _search,
                    onSearchTap: (){
                      if(_search.text.isNotEmpty){
                        controller.getSearchBoardList(keyword: _search.text);
                      } else {
                        showSnackBar(context, '검색어를 입력해주세요.');
                      }
                    },
                    onFieldSubmitted: (String value){
                      if(_search.text.isNotEmpty){
                        controller.getSearchBoardList(keyword: _search.text);
                      } else {
                        showSnackBar(context, '검색어를 입력해주세요.');
                      }
                    },
                  ),
                  bottom: SearchConditionBar(
                    mediaHeight(context, 0.06),
                    currentIndex: controller.conditionIndex.value,
                    onTap: (index){
                      setState(() {
                        controller.conditionIndex.value = index;
                      });
                    },
                    orderTap: (order){
                      setState(() {
                        controller.orderBy.value = order;
                      });
                    },
                  ),
                ),
              ],
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                child: Builder(
                    builder: (context) {
                      if(_search.text.isNotEmpty){
                        return controller.obx((boardList)=> CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                                  child: RichText(
                                    text: TextSpan(
                                        style: CustomTextStyle.w500(context, color: Colors.grey),
                                        children: [
                                          TextSpan(
                                              text: "'${_search.text}'",
                                              style: CustomTextStyle.w600(context, color: Colors.black)
                                          ),
                                          TextSpan(
                                              text: '(으)로 검색한 ${controller.boardList.length}건의 검색결과'),
                                        ]
                                    ),
                                  )
                              ),
                            ),
                            if(controller.cafeList.isNotEmpty) SliverPadding(
                              padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.033)),
                              sliver: SliverToBoxAdapter(
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(text: '카페 ', style: CustomTextStyle.w500(context, scale: 0.025)),
                                        TextSpan(text: '${controller.cafeList.length}건', style: CustomTextStyle.w600(context, scale: 0.025, color: CustomColors.main)),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            if(controller.cafeList.isNotEmpty) SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                Board board = controller.cafeList[index];
                                return SearchBoardCard(board);
                              },
                                childCount: controller.cafeList.length < 3 ? controller.cafeList.length : 3,
                              ),
                            ),
                            if(controller.cafeList.length > 3) SliverToBoxAdapter(
                              child: CustomTextButton('카페 검색 결과 더보기', (){
                                Get.to(() => BoardListPage(0));
                              }, color: CustomColors.hint),
                            ),
                            if(controller.foodList.isNotEmpty) SliverPadding(
                              padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.033)),
                              sliver: SliverToBoxAdapter(
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(text: '음식점 ', style: CustomTextStyle.w500(context, scale: 0.025)),
                                        TextSpan(text: '${controller.foodList.length}건', style: CustomTextStyle.w600(context, scale: 0.025, color: CustomColors.main)),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            if(controller.foodList.isNotEmpty) SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                Board board = controller.foodList[index];
                                return SearchBoardCard(board);
                              },
                                childCount: controller.foodList.length < 3 ? controller.foodList.length : 3,
                              ),
                            ),
                            if(controller.foodList.length > 3) SliverToBoxAdapter(
                              child: CustomTextButton('음식점 검색 결과 더보기', (){
                                Get.to(() => BoardListPage(1));
                              }, color: CustomColors.hint),
                            ),
                            if(controller.shoppingList.isNotEmpty) SliverPadding(
                              padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.033)),
                              sliver: SliverToBoxAdapter(
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(text: '쇼핑몰 ', style: CustomTextStyle.w500(context, scale: 0.025)),
                                        TextSpan(text: '${controller.shoppingList.length}건', style: CustomTextStyle.w600(context, scale: 0.025, color: CustomColors.main)),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            if(controller.shoppingList.isNotEmpty) SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                Board board = controller.shoppingList[index];
                                return SearchBoardCard(board);
                              },
                                childCount: controller.shoppingList.length < 3 ? controller.shoppingList.length : 3,
                              ),
                            ),
                            if(controller.shoppingList.length > 3) SliverToBoxAdapter(
                              child: CustomTextButton('쇼핑몰 검색 결과 더보기', (){
                                Get.to(() => BoardListPage(2));
                              }, color: CustomColors.hint),
                            ),
                            if(controller.hotelList.isNotEmpty) SliverPadding(
                              padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.033)),
                              sliver: SliverToBoxAdapter(
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(text: '호텔 ', style: CustomTextStyle.w500(context, scale: 0.025)),
                                        TextSpan(text: '${controller.hotelList.length}건', style: CustomTextStyle.w600(context, scale: 0.025, color: CustomColors.main)),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            if(controller.hotelList.isNotEmpty) SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                Board board = controller.hotelList[index];
                                return SearchBoardCard(board);
                              },
                                childCount: controller.hotelList.length < 3 ? controller.hotelList.length : 3,
                              ),
                            ),
                            if(controller.hotelList.length > 3) SliverToBoxAdapter(
                              child: CustomTextButton('호텔 검색 결과 더보기', (){
                                Get.to(() => BoardListPage(3));
                              }, color: CustomColors.hint),
                            ),
                            if(controller.groundList.isNotEmpty) SliverPadding(
                              padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.033)),
                              sliver: SliverToBoxAdapter(
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(text: '운동장 ', style: CustomTextStyle.w500(context, scale: 0.025)),
                                        TextSpan(text: '${controller.groundList.length}건', style: CustomTextStyle.w600(context, scale: 0.025, color: CustomColors.main)),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            if(controller.groundList.isNotEmpty) SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                Board board = controller.groundList[index];
                                return SearchBoardCard(board);
                              },
                                childCount: controller.groundList.length < 3 ? controller.groundList.length : 3,
                              ),
                            ),
                            if(controller.groundList.length > 3) SliverToBoxAdapter(
                              child: CustomTextButton('운동장 검색 결과 더보기', (){
                                Get.to(() => BoardListPage(4));
                              }, color: CustomColors.hint),
                            ),
                            if(controller.talkList.isNotEmpty) SliverPadding(
                              padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.033)),
                              sliver: SliverToBoxAdapter(
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(text: '수다방 ', style: CustomTextStyle.w500(context, scale: 0.025)),
                                        TextSpan(text: '${controller.talkList.length}건', style: CustomTextStyle.w600(context, scale: 0.025, color: CustomColors.main)),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            if(controller.talkList.isNotEmpty) SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                Board board = controller.talkList[index];
                                return SearchBoardCard(board);
                              },
                                childCount: controller.talkList.length < 3 ? controller.talkList.length : 3,
                              ),
                            ),
                            if(controller.talkList.length > 3) SliverToBoxAdapter(
                              child: CustomTextButton('수다방 검색 결과 더보기', (){
                                Get.to(() => BoardListPage(5, query: _search.text));
                              }, color: CustomColors.hint),
                            ),
                          ],
                        ),
                            onLoading: const LoadingView(message: '검색중입니다...',),
                            onEmpty: SliverEmpty('${_search.text}에 대한 검색 결과가 없습니다.')
                        );
                      } else {
                        return GetBuilder<PopularSearchListController>(
                            init: PopularSearchListController(context),
                            builder: (PopularSearchListController popularController) => popularController.obx((searchList) => Container(
                              margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                              child: CustomScrollView(
                                slivers: [
                                  SliverToBoxAdapter(
                                      child: Text('인기 검색어', style: CustomTextStyle.w600(context, scale: 0.02))
                                  ),
                                  SliverList(delegate: SliverChildBuilderDelegate((context, index){
                                    final Search search = searchList![index];
                                    return Row(
                                      children: [
                                        Text('${index + 1}. ', style: CustomTextStyle.w500(context)),
                                        Expanded(
                                            child: PopularSearchCard(search, (String keyword){
                                              setState(() {
                                                _search.text = keyword;
                                                controller.getSearchBoardList(keyword: keyword);
                                              });
                                            })),
                                      ],
                                    );
                                  },
                                      childCount: searchList!.length
                                  ),
                                  )
                                ],
                              ),
                            ),
                              onLoading: const LoadingView(message: '인기 검색어를 불러오고 있습니다.'),
                              onEmpty: const EmptyView(message: '인기 검색어가 없습니다.',)
                            )
                        );
                      }
                    }
                ),
              ),
            ),
          );
        }
    );
  }
}
