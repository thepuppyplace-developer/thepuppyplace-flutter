import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/common.dart';

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
          minLeadingWidth: mediaWidth(context, 0.044),
          contentPadding: EdgeInsets.zero,
          leading: SvgPicture.asset(icon, height: mediaHeight(context, 0.03), color: iconColor,),
          title: Text(title, style: CustomTextStyle.w500(context, color: textColor ?? Colors.black)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}