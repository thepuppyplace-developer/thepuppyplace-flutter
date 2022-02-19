import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../util/customs.dart';

class LoginButton extends StatelessWidget {
  final String title, icon;
  final Function() onPressed;
  final Color? color, textColor, iconColor;
  final EdgeInsets? margin;

  LoginButton({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.color,
    this.textColor,
    this.iconColor,
    this.margin,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.044)),
        borderRadius: BorderRadius.circular(mediaHeight(context, 1)),
        color: color ?? CustomColors.main,
        child: ListTile(
          minLeadingWidth: mediaWidth(context, 0.05),
          contentPadding: EdgeInsets.zero,
          leading: SvgPicture.asset(icon, height: mediaHeight(context, 0.03), color: iconColor,),
          title: Text(title, style: CustomTextStyle.w500(context, color: textColor ?? Colors.black)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

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
      padding: padding,
      height: height ?? mediaHeight(context, 0.05),
      width: width ?? mediaWidth(context, 1),
      child: CupertinoButton(
        color: color ?? CustomColors.main,
        child: Text(title, style: CustomTextStyle.w500(context, color: textColor ?? Colors.black)),
        onPressed: onPressed,
      ),
    );
  }
}

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


