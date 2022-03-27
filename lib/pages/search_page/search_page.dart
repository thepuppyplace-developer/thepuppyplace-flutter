import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search/search_controller.dart';
import '../../util/common.dart';

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
                centerTitle: false,
                title: Text('검색', style: CustomTextStyle.w500(context, scale: 0.022)),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index){

                }),
              )
            ],
          ),
        );
      }
    );
  }
}
