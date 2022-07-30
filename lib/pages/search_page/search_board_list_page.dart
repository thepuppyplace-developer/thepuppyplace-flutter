import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/search_board_list_controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/search_board_list_view.dart';
import 'package:thepuppyplace_flutter/widgets/tab_bars/search_condition_bar.dart';
import 'package:thepuppyplace_flutter/widgets/tab_bars/search_tab_bar.dart';

class SearchBoardListPage extends StatefulWidget {
  static const String routeName = '/searchBoardListPage';
  const SearchBoardListPage({Key? key}) : super(key: key);

  @override
  State<SearchBoardListPage> createState() => _SearchBoardListPageState();
}

class _SearchBoardListPageState extends State<SearchBoardListPage> {
  TextEditingController _queryController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(text: Get.arguments);
    _query = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchBoardListController>(
        init: SearchBoardListController(context, RxString(_query)),
        builder: (SearchBoardListController controller) {
          return GestureDetector(
            onTap: (){
              unFocus(context);
            },
            child: Scaffold(
              body: NestedScrollView(
                  headerSliverBuilder: (context, inner) => [
                    SliverAppBar(
                      snap: true,
                      floating: true,
                      pinned: true,
                      title: InsertSearchTabBar(
                        mediaHeight(context, 0.07),
                        margin: EdgeInsets.zero,
                        onChanged: (query){},
                        onSearchTap: (query){
                          controller.query.value = query;
                        },
                        controller: _queryController,
                      ),
                      bottom: SearchConditionBar(
                          mediaHeight(context, 0.06),
                          currentIndex: controller.conditionIndex.value,
                          onTap: (condition){
                            setState(() {
                              controller.conditionIndex.value = condition;
                            });
                          },
                          order: orderText(controller.orderBy.value),
                          orderTap: (order){
                            setState(() {
                              controller.orderBy.value = order;
                            });
                          }
                      ),
                    )
                  ],
                  body: SearchBoardListView(_query)
              ),
            ),
          );
        }
    );
  }
}
