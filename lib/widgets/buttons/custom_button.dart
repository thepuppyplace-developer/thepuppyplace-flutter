import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final double? height, width;
  final EdgeInsets? margin, padding;
  final Color? color, textColor;

  const CustomButton({
    required this.title,
    required this.onPressed,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.color,
    this.textColor,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height ?? mediaHeight(context, 0.05),
      width: width ?? mediaWidth(context, 1),
      child: CupertinoButton(
        padding: padding ?? EdgeInsets.zero,
        color: color ?? CustomColors.main,
        child: Text(title, style: CustomTextStyle.w500(context, color: textColor ?? Colors.black)),
        onPressed: onPressed,
      ),
    );
  }
}
