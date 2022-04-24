import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/search/popular_keyword_list_controller.dart';
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
                ),
              ],
              body: Builder(
                  builder: (context) {
                    if(_search.text.isNotEmpty){
                      return CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                                margin: EdgeInsets.all(mediaWidth(context, 0.033)),
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
                          controller.obx((List<Board>? boardList){
                            return SliverPadding(
                              padding: EdgeInsets.all(mediaWidth(context, 0.033)),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate((context, index){
                                  Board board = boardList![index];
                                  return SearchBoardCard(board);
                                },
                                    childCount: boardList!.length,
                                ),
                              ),
                            );
                          },
                              onLoading: const SliverLoading(message: '검색중입니다...'),
                              onEmpty: SliverEmpty('${_search.text}에 대한 검색 결과가 없습니다.')
                          )
                        ],
                      );
                    } else {
                      return GetBuilder<PopularSearchListController>(
                          init: PopularSearchListController(context),
                          builder: (PopularSearchListController popluarController) => popluarController.obx((searchList) => Container(
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
                          ))
                      );
                    }
                  }
              ),
            ),
          );
        }
    );
  }
}
