import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';


class CustomCheckButtonItem extends StatelessWidget {
  final Widget child;
  final Function(bool) onTap;
  final bool value;
  final bool? side;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const CustomCheckButtonItem({
    required this.child,
    required this.onTap,
    required this.value,
    this.side,
    this.height,
    this.margin,
    this.padding,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: side == false ? null : BoxDecoration(
        border: Border.all(color: value ? CustomColors.main : Colors.black),
        borderRadius: BorderRadius.circular(5)
      ),
      margin: margin,
      child: CupertinoButton(
        padding: padding ?? EdgeInsets.all(mediaWidth(context, 0.033)),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(child: child),
            Icon(Icons.check, color: value ? CustomColors.main :CustomColors.emptySide)
          ],
        ),
        onPressed: (){
          onTap(!value);
        },
      ),
    );
  }
}
