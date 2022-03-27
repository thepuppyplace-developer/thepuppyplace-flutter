import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class CategoryTabBar extends StatelessWidget with PreferredSizeWidget {
  final double height;
  final int currentIndex;
  final List<String> categoryList;
  final Function(int) onTap;

  const CategoryTabBar(this.height, {
    required this.currentIndex,
    required this.categoryList,
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
      height: height,
      child: ListView.builder(
        itemExtent: mediaWidth(context, 0.2),
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(categoryList[index], style: CustomTextStyle.w600(context, scale: 0.02)),
                onPressed: (){
                  onTap(index);
                },
              ),
              if(currentIndex == index)const Divider(
                color: CustomColors.main,
                height: 0,
                thickness: 2,
              )
            ],
          );
        },
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
