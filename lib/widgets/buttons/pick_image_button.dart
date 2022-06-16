import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class PickImageButton extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets? margin;
  final String? text;

  const PickImageButton({this.onTap, this.margin, this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: mediaHeight(context, 0.1),
      width: mediaHeight(context, 0.1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CustomColors.empty,
        border: Border.all(color: CustomColors.emptySide),
        borderRadius: BorderRadius.circular(5)
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, color: Colors.grey, size: mediaHeight(context, 0.03)),
            Text(text ?? '사진 추가', style: CustomTextStyle.w500(context, color: Colors.grey, scale: 0.015),)
          ],
        ),
        onPressed: onTap
      ),
    );
  }
}
