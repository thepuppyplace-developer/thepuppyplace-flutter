import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final Color? color;

  const CustomTextButton({
    required this.title,
    required this.onPressed,
    this.padding,
    this.color,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding ?? EdgeInsets.zero,
      child: Text(title, style: CustomTextStyle.w500(context, color: color ?? Colors.blue)),
      onPressed: onPressed,
    );
  }
}
