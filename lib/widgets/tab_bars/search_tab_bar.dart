import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../pages/search_page/search_page.dart';
import '../text_fields/custom_text_field.dart';

class SearchTabBar extends StatelessWidget with PreferredSizeWidget{

  final double height;
  final EdgeInsets? margin;

  const SearchTabBar(this.height, {
    this.margin,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomTextField(
    textFieldType: TextFieldType.outline,
    height: height,
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
  final EdgeInsets? margin;
  final String? hintText;
  final Function(String) onChanged;

  const InsertSearchTabBar(this.height, {
    this.margin,
    this.hintText,
    required this.onChanged,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomTextField(
    height: height,
    textFieldType: TextFieldType.outline,
    textInputAction: TextInputAction.search,
    autofocus: false,
    padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
    margin: margin ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
    fillColor: CustomColors.empty,
    sideColor: CustomColors.emptySide,
    keyboardType: TextInputType.text,
    hintText: hintText ?? '지역, 매장명 검색',
    suffixIcon: Icon(Icons.search, size: mediaHeight(context, 0.03), color: CustomColors.hint),
    borderRadius: mediaHeight(context, 1),
    onChanged: onChanged,
  );
}