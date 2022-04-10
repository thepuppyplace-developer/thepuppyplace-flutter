import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onTap;

  const CustomIconButton({
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.03)),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(bottom: mediaHeight(context, 0.01)),
              child: Icon(icon, size: mediaHeight(context, 0.03), color: Colors.black,)),
          Text(text, style: CustomTextStyle.w500(context, scale: 0.02))
        ],
      ),
      onPressed: onTap,
    );
  }
}
