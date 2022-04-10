import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../pages/search_page/search_page.dart';
import '../buttons/custom_text_button.dart';
import '../text_fields/out_line_text_field.dart';

class SearchTabBar extends StatelessWidget with PreferredSizeWidget{

  final double height;
  final EdgeInsets? margin;

  const SearchTabBar(this.height, {
    this.margin,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => OutlineTextField(
    height: height,
    onChanged: (String search){},
    onTap: (){
      Get.to(() => const SearchPage());
    },
    padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
    autofocus: false,
    readOnly: true,
    margin: margin ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
    fillColor: CustomColors.empty,
    sideColor: CustomColors.emptySide,
    controller: null,
    keyboardType: null,
    hintText: '지역, 매장명 검색',
    suffixIcon: const Icon(Icons.search, color: Colors.grey),
    borderRadius: mediaHeight(context, 1),
  );

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class InsertSearchTabBar extends StatelessWidget{

  final double height;
  final TextEditingController controller;
  final EdgeInsets? margin;
  final String? hintText;
  final Function() onSearchTap;
  final Function(String) onFieldSubmitted;

  const InsertSearchTabBar(this.height, {
    required this.controller,
    this.margin,
    this.hintText,
    required this.onSearchTap,
    required this.onFieldSubmitted,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => OutlineTextField(
    onChanged: (String search){},
    onFieldSubmitted: onFieldSubmitted,
    textInputAction: TextInputAction.search,
    autofocus: false,
    padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
    margin: margin ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
    fillColor: CustomColors.empty,
    sideColor: CustomColors.emptySide,
    controller: controller,
    keyboardType: TextInputType.text,
    hintText: hintText ?? '지역, 매장명 검색',
    suffixIcon: CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(Icons.search, color: CustomColors.hint),
      onPressed: onSearchTap,
    ),
    borderRadius: mediaHeight(context, 1),
  );
}