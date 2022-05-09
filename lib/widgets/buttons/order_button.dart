import 'package:flutter/material.dart';

import '../../util/common.dart';

class OrderButton extends StatelessWidget {
  final String order;
  final Function(String) onSelected;

  const OrderButton({
    required this.order,
    required this.onSelected,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(mediaWidth(context, 0.033)),
      alignment: Alignment.centerRight,
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(order, style: CustomTextStyle.w500(context, color: CustomColors.hint)),
            Icon(Icons.keyboard_arrow_down_sharp, size: mediaHeight(context, 0.02), color: CustomColors.hint),
          ],
        ),
        onSelected: onSelected,
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'date',
            child: const Text('최신순'),
            textStyle: CustomTextStyle.w500(context),
          ),
          PopupMenuItem(
            value: 'view',
            child: const Text('인기순'),
            textStyle: CustomTextStyle.w500(context),
          ),
        ],
      ),
    );
  }
}

enum OrderType{date, view}
