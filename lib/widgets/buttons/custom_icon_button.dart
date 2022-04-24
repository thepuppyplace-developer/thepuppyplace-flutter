import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class CustomIconButton extends StatelessWidget {
  final IconButtonType? type;
  final Color? color;
  final IconData icon;
  final String? text;
  final Function() onTap;

  const CustomIconButton({
    this.type,
    this.color,
    required this.icon,
    this.text,
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconData _baseIcon = icon;
    final Function() _baseFunction = onTap;
    final Color _baseColor = color ?? Colors.black;

    switch(type){
      case IconButtonType.withText: return CupertinoButton(
        padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.03)),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: mediaHeight(context, 0.01)),
                child: Icon(_baseIcon, size: mediaHeight(context, 0.03), color: _baseColor)),
            Text(text ?? '', style: CustomTextStyle.w500(context, scale: 0.02))
          ],
        ),
        onPressed: _baseFunction,
      );
      default: return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(_baseIcon, size: mediaHeight(context, 0.03), color: _baseColor),
        onPressed: _baseFunction,
      );
    }
  }
}

enum IconButtonType{withText}