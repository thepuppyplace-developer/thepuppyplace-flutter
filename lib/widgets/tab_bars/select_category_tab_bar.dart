import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class SelectCategoryTabBar extends StatelessWidget with PreferredSizeWidget {
  final double height;
  final int categoryIndex;
  final List<String> categoryList;
  final Function(int) onChanged;
  const SelectCategoryTabBar(this.height, {required this.categoryIndex, required this.categoryList, required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
      child: Row(
        children: [
          for(int index = 0; index < categoryList.length; index++) Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: categoryIndex == index ? CustomColors.main : CustomColors.hint)
                    ),
                    margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.005)),
                    child: Text(categoryList[index], style: CustomTextStyle.w500(context, color: categoryIndex == index ? CustomColors.main : CustomColors.hint, scale: 0.015))),
                onPressed: (){
                  onChanged(index);
                },
              )
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
