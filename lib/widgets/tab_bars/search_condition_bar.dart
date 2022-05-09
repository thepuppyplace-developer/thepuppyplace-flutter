import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/order_button.dart';
import '../../pages/search_page/search_page.dart';
import '../text_fields/custom_text_field.dart';

class SearchConditionBar extends StatelessWidget with PreferredSizeWidget{

  final double height;
  final int currentIndex;
  final String order;
  final Function(int) onTap;
  final Function(String) orderTap;

  SearchConditionBar(this.height, {
    required this.currentIndex,
    required this.order,
    required this.onTap,
    required this.orderTap,
    Key? key}) : super(key: key);
  final List<String> _conditionList = <String>[
    '전체', '제목', '내용', '제목+내용'
  ];

  Widget build(BuildContext context) => Container(
    height: height,
    alignment: Alignment.centerLeft,
    child: Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
            scrollDirection: Axis.horizontal,
            child: Row(
                children: [
                  for(int index = 0; index < _conditionList.length; index++) _tabBar(
                    context,
                    condition: _conditionList[index],
                    index: index
                  )
                ]
            ),
          ),
        ),
        OrderButton(
            order: order,
            onSelected: orderTap
        )
      ],
    ),
  );

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);

  Widget _tabBar(BuildContext context, {required String condition, required int index}) => CupertinoButton(
    padding: EdgeInsets.zero,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.005)).copyWith(right: mediaWidth(context, 0.0165)),
      padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.01)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: currentIndex != index ? null : CustomColors.main,
        border: Border.all(color: currentIndex == index ? Colors.transparent : CustomColors.emptySide),
        borderRadius: BorderRadius.circular(mediaHeight(context, 1)),
      ),
      child: Text(condition, style: CustomTextStyle.w500(context, color: index == currentIndex ? Colors.white : CustomColors.hint)),
    ),
    onPressed: (){
      onTap(index);
    },
  );
}