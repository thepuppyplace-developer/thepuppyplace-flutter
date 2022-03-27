import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

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
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          }
      )
  );
}

class SliverError extends StatelessWidget {
  final String? error;
  const SliverError(this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
          alignment: Alignment.center,
          child: Text(error ?? 'error')),
    );
  }
}

class SliverLoading extends StatelessWidget {
  const SliverLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Container());
  }
}



