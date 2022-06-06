import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final Color? disabledColor;
  final Color? textColor;
  final Color? sideColor;
  final double? scale;

  const CustomButton({
    required this.title,
    required this.onPressed,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
    this.padding,
    this.color,
    this.disabledColor,
    this.sideColor,
    this.textColor,
    this.scale,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 5),
          boxShadow: sideColor == null ? null : [
            BoxShadow(color: sideColor ?? CustomColors.hint, blurStyle: BlurStyle.normal, blurRadius: 0.5),
            const BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.inner, blurRadius: 0),
          ]
      ),
      margin: margin,
      height: height ?? mediaHeight(context, 0.06),
      padding: padding ?? EdgeInsets.zero,
      width: width ?? mediaWidth(context, 1),
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(borderRadius ?? 5),
        padding: EdgeInsets.zero,
        disabledColor: disabledColor ?? CustomColors.hint,
        color: color ?? CustomColors.main,
        child: Text(title, style: CustomTextStyle.w500(context, color: textColor ?? Colors.white,scale: scale ?? 0.02)),
        onPressed: onPressed,
      ),
    );
  }
}
