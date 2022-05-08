import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/search_board_controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/search_board_list_view.dart';
import 'package:thepuppyplace_flutter/widgets/cards/search_board_card.dart';
import 'package:thepuppyplace_flutter/widgets/tab_bars/search_condition_bar.dart';
import 'package:thepuppyplace_flutter/widgets/tab_bars/search_tab_bar.dart';

import '../../widgets/text_fields/custom_text_field.dart';

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
                title: CustomTextField(
                  textFieldType: TextFieldType.outline,
                  height: mediaHeight(context, 0.07),
                  onTap: (){
                    Get.back();
                  },
                  padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
                  autofocus: false,
                  readOnly: true,
                  margin: EdgeInsets.zero,
                  fillColor: CustomColors.empty,
                  sideColor: CustomColors.emptySide,
                  controller: _queryController,
                  hintText: '지역, 매장명 검색',
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  borderRadius: mediaHeight(context, 1),
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
