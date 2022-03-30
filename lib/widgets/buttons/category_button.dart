import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/board_page/board_list_page.dart';
import '../../util/common.dart';

class CategoryButton extends StatelessWidget {
  final String category;
  final String image;
  final int currentIndex;

  const CategoryButton({required this.category, required this.image, required this.currentIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        width: mediaWidth(context, 1/3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomColors.emptySide),
        ),
        child: Column(
          children: [
            Image.asset(image),
            Text(category, style: CustomTextStyle.w600(context)),
          ],
        ),
      ),
      onPressed: (){
        Get.to(() => BoardListPage(currentIndex));
      }
    );
  }
}
