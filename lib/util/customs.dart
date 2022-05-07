import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../widgets/animations/SizedAnimation.dart';
import 'png_list.dart';

mixin CustomThemeData implements ThemeData{
  static ThemeData light = ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      indicatorColor: CustomColors.main,
      appBarTheme: const AppBarTheme(
          color: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)
      ),
      scaffoldBackgroundColor: Colors.white,
      pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }
      ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      )
    )
  );
}




