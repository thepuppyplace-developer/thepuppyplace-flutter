import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';
import '../../util/png_list.dart';
import '../animations/SizedAnimation.dart';

class SliverLoading extends StatelessWidget {
  final String? message;
  final bool? animated;

  const SliverLoading({
    this.message,
    this.animated = true,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(animated ?? true) Container(
              height: mediaHeight(context, 0.1),
              width: mediaHeight(context, 0.1),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(PngList.app_logo)
                  )
              ),
            ),
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
  final bool? imageVisible;
  const SliverEmpty(
      this.message, {
        this.imageVisible = true,
        Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(imageVisible ?? true) Container(
              height: mediaHeight(context, 0.1),
              width: mediaHeight(context, 0.1),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(PngList.app_logo)
                  )
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.04)),
                child: Text(message, style: CustomTextStyle.w500(context, color: CustomColors.hint))),
          ],
        ),
      ),
    );
  }
}
