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
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(mediaHeight(context, 0.02)),
        child: const CupertinoActivityIndicator(),
      ),
    );
  }
}

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
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
                  child: Text('페이지 이동중입니다', style: CustomTextStyle.w500(context, color: CustomColors.hint))),
              const CupertinoActivityIndicator()
            ],
          ),
        ),
      ),
    );
  }
}


