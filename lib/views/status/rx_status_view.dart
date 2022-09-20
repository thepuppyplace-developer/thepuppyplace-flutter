import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';

class LoadingView extends StatelessWidget {
  final String? message;
  final double? height;
  final EdgeInsets? margin;

  const LoadingView({
    this.message,
    this.height,
    this.margin,
    Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? baseVerticalPadding(context),
      height: height,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            height: mediaHeight(context, 0.1),
            width: mediaHeight(context, 0.1),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
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
    );
  }
}

class EmptyView extends StatelessWidget {
  final String? message;
  final double? height;
  final EdgeInsets? margin;
  final bool? imageVisible;

  const EmptyView({
    this.message,
    this.height,
    this.margin,
    this.imageVisible = true,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? baseVerticalPadding(context),
      height: height,
      alignment: Alignment.center,
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
              child: Text(message ?? '등록된 게시글이 없습니다', style: CustomTextStyle.w500(context, color: CustomColors.hint))),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String? error;
  final TextStyle? messageStyle;
  final double? height;

  const ErrorView(
      this.error, {
        this.messageStyle,
        this.height,
        Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: Text(error ?? '에러', style: messageStyle ?? CustomTextStyle.w500(context, color: Colors.grey)),
      ),
    );
  }
}