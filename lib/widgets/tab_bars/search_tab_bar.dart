import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../pages/search_page/search_page.dart';
import '../text_fields/out_line_text_field.dart';

class SearchTabBar extends StatelessWidget with PreferredSizeWidget{
  final double height;
  final EdgeInsets? padding;

  const SearchTabBar(this.height, {
    this.padding,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
      height: height,
      child: OutlineTextField(
        onTap: (){
          Get.to(() => const SearchPage());
        },
        height: mediaHeight(context, 0.022),
        autofocus: false,
        readOnly: true,
        margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
        fillColor: CustomColors.empty,
        sideColor: CustomColors.emptySide,
        controller: null,
        keyboardType: null,
        hintText: '지역, 매장명 검색',
        suffixIcon: const Icon(Icons.search, color: Colors.grey),
        borderRadius: mediaHeight(context, 1),
      )
  );

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
