import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/board/board_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Board.dart';
import '../../models/User.dart';
import '../../util/common.dart';
import '../buttons/custom_text_button.dart';
import 'none_text_field.dart';

class CommentField extends StatefulWidget {
  final Board board;

  const CommentField(this.board, {Key? key}) : super(key: key);

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {

  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (UserController controller) {
        return controller.obx((User? user) => Container(
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
                    onChanged: (String comment){
                      setState(() {
                        _comment = comment;
                      });
                    },
                    onFieldSubmitted: (String comment){
                    },
                    height: mediaHeight(context, 0.07),
                    keyboardType: TextInputType.text,
                    hintText: '댓글을 입력하세요.',
                  ),
                ),
                GetBuilder<BoardController>(
                  init: BoardController(widget.board),
                  builder: (BoardController controller) {
                    return CustomTextButton('등록', (){
                      controller.insertComment(context, _comment);
                      setState(() {
                        _comment = '';
                      });
                    }, color: CustomColors.main);
                  }
                )
              ],
            )
        ),
          onEmpty: Container(
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
                      onChanged: (String comment){},
                      onFieldSubmitted: (String comment){},
                      readOnly: true,
                      height: mediaHeight(context, 0.07),
                      keyboardType: TextInputType.text,
                      hintText: '로그인을 해주세요.',
                    ),
                  ),
                  CustomTextButton('로그인', (){
                    Get.toNamed('/loginPage');
                  }, color: CustomColors.main)
                ],
              )
          )
        );
      }
    );
  }
}
