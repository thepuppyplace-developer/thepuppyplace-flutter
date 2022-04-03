import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_text_button.dart';

import '../../controllers/board/search_board_controller.dart';
import '../../models/Board.dart';
import '../../models/Search.dart';
import '../../util/common.dart';
import '../../widgets/cards/board_card.dart';
import '../../widgets/cards/search_card.dart';
import '../../widgets/loadings/sliver_contents.dart';
import '../../widgets/tab_bars/search_tab_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
        init: SearchController(),
        builder: (SearchController controller) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  pinned: true,
                  title: InsertSearchTabBar(mediaHeight(context, 0.07),
                    margin: EdgeInsets.zero,
                    hintText: '찾으시는 검색어를 입력하세요.',
                    controller: controller.keywordController.value,
                    onSearchTap: (){
                      controller.getSearchBoardList();
                    },
                    onFieldSubmitted: (String value){
                      controller.getSearchBoardList();
                    },
                  ),
                ),
                controller.obx((List<Board>? boardList){
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index){
                      Board board = boardList![index];
                      return SearchBoardCard(board);
                    },
                        childCount: boardList!.length
                    ),
                  );
                },
                    onLoading: const SliverLoading(message: '검색중입니다...'),
                    onEmpty: SliverEmpty('${controller.keywordController.value.text}에 대한 검색결과가 없습니다'),
                    onError: (error) {
                      if(controller.searchList.isEmpty){
                        return SliverEmpty(error ?? '');
                      } else {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((context, index){
                            Search search = controller.searchList[index];
                            return CustomTextButton(search.keyword, (){
                              controller.deleteSearch(search.id!);
                            });
                          },
                            childCount: controller.searchList.length
                          ),
                        );
                      }
                    }
                )
              ],
            ),
          );
        }
    );
  }
}
