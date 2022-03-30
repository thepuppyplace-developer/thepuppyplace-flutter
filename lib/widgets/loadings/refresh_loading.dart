import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class RefreshLoading extends StatelessWidget {
  const RefreshLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)),
      child: const CupertinoActivityIndicator(),
    );
  }
}

class NoDataText extends StatelessWidget {
  const NoDataText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)),
      alignment: Alignment.center,
      child: Text('더 이상 항목이 없습니다.', style: CustomTextStyle.w500(context, scale: 0.02)),
    );
  }
}
