import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class RefreshContents extends StatelessWidget {
  final RefreshStatus? status;
  final String? completedText;
  final String? failedText;
  final String? idleText;

  const RefreshContents(this.status, {
    this.completedText,
    this.failedText,
    this.idleText,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    alignment: Alignment.center,
    margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)),
    child: Builder(
      builder: (BuildContext context){
        switch(status){
          case RefreshStatus.completed: {
            return Text(completedText ?? '새로고침 성공', style: CustomTextStyle.w600(context, color: CustomColors.hint));
          }
          case RefreshStatus.idle: {
            return Text(idleText ?? '새로고침 할 내용 없음', style: CustomTextStyle.w600(context, color: CustomColors.hint));
          }
          case RefreshStatus.failed: {
            return Text(failedText ?? '인터넷 연결을 확인해주세요', style: CustomTextStyle.w600(context, color: CustomColors.hint));
          }
          default: {
            return const CupertinoActivityIndicator();
          }
        }
      },
    ),
  );
}

class LoadContents extends StatelessWidget {
  final LoadStatus? status;

  final String? noMoreText;
  final String? failedText;

  const LoadContents(this.status, {
    this.noMoreText,
    this.failedText,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)),
      child: Builder(
        builder: (BuildContext context){
          switch(status){
            case LoadStatus.noMore: {
              return Text(noMoreText ?? '마지막 게시글입니다', style: CustomTextStyle.w600(context, color: CustomColors.hint));
            }
            case LoadStatus.failed: {
              return Text(failedText ?? '인터넷 연결을 확인해주세요', style: CustomTextStyle.w600(context, color: CustomColors.hint));
            }
            default: {
              return const CupertinoActivityIndicator();
            }
          }
        },
      ),
    );
  }
}




