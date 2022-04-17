import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/common.dart';
import '../buttons/custom_text_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? content;
  final String? tabText;
  final Function()? onTap;
  
  const CustomDialog({
    required this.title,
    this.content,
    this.tabText,
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title, style: CustomTextStyle.w500(context, scale: 0.02), textAlign: TextAlign.center),
      content: content == null ? null : Text(content ?? '', style: CustomTextStyle.w500(context), textAlign: TextAlign.center),
      actions: [
        CustomTextButton('취소', (){
          Get.back();
        },
          color: Colors.black,
        ),
        CustomTextButton(tabText ?? '확인', onTap,
          color: Colors.black,
        ),
      ],
    );
  }
}
