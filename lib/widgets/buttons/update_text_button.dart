import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class UpdateTextButton extends StatelessWidget {
  final String title;
  final String content;
  final Function()? onTap;

  const UpdateTextButton({
    required this.title,
    required this.content,
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: CustomTextStyle.w500(context, scale: 0.018), overflow: TextOverflow.ellipsis),
              Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.02)),
                    child: Text(content, textAlign: TextAlign.end, style: CustomTextStyle.w600(context, scale: 0.018, color: CustomColors.hint))),
              ),
              if(title != '이메일 아이디') Icon(Icons.arrow_forward_ios, size: mediaHeight(context, 0.02), color: CustomColors.hint,)
            ],
          ),
          const Divider()
        ],
      ),
      onPressed: onTap,
    );
  }
}
