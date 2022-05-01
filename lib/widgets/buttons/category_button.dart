import 'package:cached_network_image/cached_network_image.dart';
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
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 3/2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.emptySide),
                  borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  opacity: 0.7,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.colorDodge),
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(image)
                )
              ),
              child: Text(category, style: CustomTextStyle.w500(context, color: Colors.white)),
            ),
          ),
        ],
      ),
      onPressed: (){
        Get.to(() => BoardListPage(currentIndex));
      }
    );
  }
}
