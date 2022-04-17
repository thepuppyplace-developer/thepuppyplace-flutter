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
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          }
      ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      )
    )
  );
}

class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({this.message, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedAnimation(child: Image.asset(PngList.loading, height: mediaHeight(context, 0.15))),
              Container(
                  margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.04)),
                  child: Text(message ?? '페이지 이동중입니다', style: CustomTextStyle.w500(context, color: CustomColors.hint))),
              const CupertinoActivityIndicator()
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final String? message;
  const EmptyView({this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(PngList.empty, height: mediaHeight(context, 0.15)),
            Container(
                margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.04)),
                child: Text(message ?? '등록된 게시글이 없습니다', style: CustomTextStyle.w500(context, color: CustomColors.hint))),
          ],
        ),
      ),
    );
  }
}

class RecentLoading extends StatelessWidget {
  const RecentLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




