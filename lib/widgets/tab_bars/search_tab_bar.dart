import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_icon_button.dart';
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

class InsertSearchTabBar extends StatefulWidget{

  final double height;
  final EdgeInsets? margin;
  final String? hintText;
  final Function(String) onChanged;
  final Function(String) onSearchTap;

  const InsertSearchTabBar(this.height, {
    this.margin,
    this.hintText,
    required this.onChanged,
    required this.onSearchTap,
    Key? key}) : super(key: key);

  @override
  State<InsertSearchTabBar> createState() => _InsertSearchTabBarState();
}

class _InsertSearchTabBarState extends State<InsertSearchTabBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => CustomTextField(
    controller: _controller,
    height: widget.height,
    textFieldType: TextFieldType.outline,
    textInputAction: TextInputAction.search,
    autofocus: false,
    padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
    margin: widget.margin ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
    fillColor: CustomColors.empty,
    sideColor: CustomColors.emptySide,
    keyboardType: TextInputType.text,
    hintText: widget.hintText ?? '지역, 매장명 검색',
    suffixIcon: CustomIconButton(
      icon: Icons.search,
      onTap: (){
        widget.onSearchTap(_controller.text);
      },
    ),
    borderRadius: mediaHeight(context, 1),
    onChanged: widget.onChanged,
    onFieldSubmitted: (query){
      widget.onSearchTap(_controller.text);
    },
  );
}