import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final Color? color;
  final Alignment? alignment;

  const CustomTextButton(
      this.text,
      this.onPressed, {
        this.padding,
        this.color,
        this.alignment,
        Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding ?? EdgeInsets.zero,
      alignment: alignment ?? Alignment.center,
      child: Text(text, style: CustomTextStyle.w500(context, color: color ?? Colors.blue)),
      onPressed: onPressed,
    );
  }
}
