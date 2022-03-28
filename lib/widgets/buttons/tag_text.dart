import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class TagText extends StatelessWidget {
  final String text;
  final EdgeInsets? margin;

  const TagText(this.text, {this.margin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(mediaWidth(context, 0.005)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mediaHeight(context, 1)),
        color: CustomColors.main
      ),
      padding: EdgeInsets.all(mediaHeight(context, 0.005)),
      child: Text('#$text', style: CustomTextStyle.w500(context, scale: 0.012, color: CustomColors.mainText)),
    );
  }
}
