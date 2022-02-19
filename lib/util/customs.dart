import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

mixin CustomThemeData implements ThemeData{
  static ThemeData light = ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: CustomColors.background,
      indicatorColor: CustomColors.main,
      appBarTheme: const AppBarTheme(
          color: CustomColors.background,
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          }
      )
  );
}

mixin CustomColors implements Color{
  static const Color background = Color(0xFFE3F2FD);
  static const Color main = Color(0xFFFFFC93);
  static const Color hint = Color(0xFFB6B6B6);
}

mixin CustomTextStyle implements TextStyle{
  static TextStyle w100(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w100, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
  static TextStyle w200(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w200, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
  static TextStyle w300(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w300, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
  static TextStyle w400(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w400, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
  static TextStyle w500(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w500, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
  static TextStyle w600(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w600, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
  static TextStyle w700(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w700, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
  static TextStyle w800(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w800, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
  static TextStyle w900(BuildContext context, {double? scale, Color? color}) => TextStyle(fontWeight: FontWeight.w900, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black);
}