import 'package:flutter/material.dart';
import '../../util/common.dart';
import '../buttons/custom_text_button.dart';
import 'none_text_field.dart';

class CommentField extends StatelessWidget {
  final TextEditingController commentController;
  final Function() onPressed;
  const CommentField(this.commentController, this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurStyle: BlurStyle.inner, color: CustomColors.hint, blurRadius: 100, spreadRadius: 5)
          ]
      ),
      height: mediaHeight(context, 0.07),
      child: Row(
        children: [
          Expanded(
            child: NoneTextField(
              height: mediaHeight(context, 0.07),
              controller: commentController,
              keyboardType: TextInputType.text,
              hintText: '댓글을 입력하세요.',
            ),
          ),
          CustomTextButton('등록', onPressed, color: CustomColors.main)
        ],
      )
    );
  }
}
