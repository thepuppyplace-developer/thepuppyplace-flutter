import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/widgets/dialogs/custom_dialog.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/BoardComment.dart';
import '../../models/NestedComment.dart';
import '../../models/User.dart';
import '../../util/common.dart';
import '../buttons/custom_text_button.dart';
import 'user_profile_card.dart';

class CommentCard extends GetWidget<UserController> {
  final BoardComment comment;
  final Function(BoardComment) onComment;
  final Function() onCommentDelete;
  final Function(NestedComment) onNestedCommentDelete;

  const CommentCard(this.comment, this.onComment, {required this.onCommentDelete, required this.onNestedCommentDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: UserProfileCard(comment.user)
            ),
            controller.obx((User? user){
              if(user!.id == comment.userId){
                return CustomTextButton('삭제', (){
                  showDialog(context: context, builder: (context) => CustomDialog(title: '댓글을 삭제하시겠습니까?', onTap: onCommentDelete));
                }, color: CustomColors.main);
              } else {
                return Container();
              }
            })
          ],
        ),
        Text(comment.comment, style: CustomTextStyle.w500(context)),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CustomTextButton('좋아요', (){}, color: CustomColors.hint),
                  CustomTextButton('답글달기', (){
                    onComment(comment);
                  }, color: CustomColors.hint),
                ],
              ),
            ),
            Text(beforeDate(comment.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint))
          ],
        ),
        if(comment.nestedCommentList.isNotEmpty) Column(
            children: [
              for(NestedComment nestedComment in comment.nestedCommentList)
                Container(
                    margin: EdgeInsets.only(left: mediaWidth(context, 0.05)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: UserProfileCard(comment.user)
                            ),
                            controller.obx((User? user){
                              if(comment.userId == user!.id) {
                                return CustomTextButton(
                                    '삭제', () {
                                  showDialog(context: context, builder: (context) => CustomDialog(title: '댓글을 삭제하시겠습니까?', onTap: (){
                                    onNestedCommentDelete(nestedComment);
                                  }));
                                }, color: CustomColors.main);
                              } else {
                                return Container();
                              }
                            })
                          ],
                        ),
                        Text(nestedComment.comment, style: CustomTextStyle.w500(context)),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CustomTextButton('좋아요', (){}, color: CustomColors.hint),
                                  CustomTextButton('답글달기', (){}, color: CustomColors.hint),
                                ],
                              ),
                            ),
                            Text(beforeDate(comment.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint))
                          ],
                        ),
                      ],
                    )
                )
            ]
        )
      ],
    );
  }
}
