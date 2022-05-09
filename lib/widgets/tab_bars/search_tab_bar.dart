import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_board_list_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_icon_button.dart';
import '../../pages/search_page/search_page.dart';
import '../text_fields/custom_text_field.dart';

class SearchTabBar extends StatelessWidget with PreferredSizeWidget{

  final double height;
  final EdgeInsets? margin;
  final String? query;
  final Function() onTap;

  const SearchTabBar(
      this.height, {
        required this.onTap,
        this.margin,
        this.query,
        Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomTextField(
    textFieldType: TextFieldType.outline,
    height: height,
    onTap: onTap,
    padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
    autofocus: false,
    readOnly: true,
    margin: margin ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
    fillColor: CustomColors.empty,
    sideColor: CustomColors.emptySide,
    controller: null,
    hintText: query ?? '지역, 매장명 검색',
    suffixIcon: const Icon(Icons.search, color: Colors.grey),
    borderRadius: mediaHeight(context, 1),
  );

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class InsertSearchTabBar extends StatefulWidget{

  final double height;
  final EdgeInsets? margin;
  final String? hintText;
  final Function(String) onChanged;
  final Function(String) onSearchTap;
  final TextEditingController controller;

  const InsertSearchTabBar(this.height, {
    this.margin,
    this.hintText,
    required this.controller,
    required this.onChanged,
    required this.onSearchTap,
    Key? key}) : super(key: key);

  @override
  State<InsertSearchTabBar> createState() => _InsertSearchTabBarState();
}

class _InsertSearchTabBarState extends State<InsertSearchTabBar> {
  @override
  Widget build(BuildContext context) => CustomTextField(
    controller: widget.controller,
    height: widget.height,
    textFieldType: TextFieldType.outline,
    textInputAction: TextInputAction.search,
    autofocus: false,
    padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
    margin: widget.margin ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
    fillColor: CustomColors.empty,
    sideColor: CustomColors.emptySide,
    keyboardType: TextInputType.text,
    hintText: '지역, 매장명 검색',
    suffixIcon: CustomIconButton(
      icon: Icons.search,
      onTap: (){
        widget.onSearchTap(widget.controller.text);
      },
    ),
    borderRadius: mediaHeight(context, 1),
    onChanged: widget.onChanged,
    onFieldSubmitted: widget.onSearchTap,
  );
}