import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';
import '../../util/png_list.dart';
import '../animations/SizedAnimation.dart';

class SliverLoading extends StatelessWidget {
  final String? message;

  const SliverLoading({
    this.message,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
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
    );
  }
}

class SliverEmpty extends StatelessWidget {
  final String message;
  const SliverEmpty(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(PngList.empty, height: mediaHeight(context, 0.15)),
            Container(
                margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.04)),
                child: Text(message, style: CustomTextStyle.w500(context, color: CustomColors.hint))),
          ],
        ),
      ),
    );
  }
}