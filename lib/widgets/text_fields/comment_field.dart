import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Member.dart';
import '../../util/common.dart';
import '../buttons/custom_text_button.dart';
import 'custom_text_field.dart';

class CommentField extends StatelessWidget {
  final TextEditingController commentController;
  final Function(String) onPressed;

  const CommentField({
    required this.commentController,
    required this.onPressed,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<UserController>(
          init: UserController(),
          builder: (UserController controller) {
            return controller.obx((Member? user) =>
                Column(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(blurStyle: BlurStyle.inner,
                                  color: CustomColors.hint,
                                  blurRadius: 100,
                                  spreadRadius: 5)
                            ]
                        ),
                        height: mediaHeight(context, 0.07),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                textFieldType: TextFieldType.none,
                                controller: commentController,
                                onFieldSubmitted: onPressed,
                                height: mediaHeight(context, 0.07),
                                keyboardType: TextInputType.text,
                                hintText: '댓글을 입력하세요.',
                              ),
                            ),
                            CustomTextButton('등록', (){
                              onPressed(commentController.text);
                            }, color: CustomColors.main)
                          ],
                        )
                    ),
                  ],
                ),
                onEmpty: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(blurStyle: BlurStyle.inner,
                              color: CustomColors.hint,
                              blurRadius: 100,
                              spreadRadius: 5)
                        ]
                    ),
                    height: mediaHeight(context, 0.07),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            textFieldType: TextFieldType.none,
                            readOnly: true,
                            height: mediaHeight(context, 0.07),
                            keyboardType: TextInputType.text,
                            hintText: '로그인을 해주세요.',
                          ),
                        ),
                        CustomTextButton('로그인', () {
                          Get.toNamed('/loginPage');
                        }, color: CustomColors.main)
                      ],
                    )
                )
            );
          }
      ),
    );
  }
}