import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/search_board_controller.dart';
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
  final String _query = Get.arguments;
  final TextEditingController _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _queryController.text = _query;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchBoardListController>(
      init: SearchBoardListController(context, _query),
      builder: (SearchBoardListController controller) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, inner) => [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                title: InsertSearchTabBar(
                    mediaHeight(context, 0.07),
                    onChanged: (query){
                    },
                  margin: EdgeInsets.zero,
                ),
                bottom: SearchConditionBar(
                    mediaHeight(context, 0.06),
                    currentIndex: controller.conditionIndex.value,
                    onTap: (condition){
                      setState(() {
                        controller.conditionIndex.value = condition;
                      });
                    },
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
        );
      }
    );
  }
}
