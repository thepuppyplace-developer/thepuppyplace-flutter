import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
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
  final Function(BoardComment) onLike;
  final Function() onCommentDelete;
  final Function(NestedComment) onNestedCommentDelete;

  const CommentCard(this.comment, {required this.onComment, required this.onLike, required this.onCommentDelete, required this.onNestedCommentDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
      padding: EdgeInsets.all(mediaWidth(context, 0.033)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 20)
          ]
      ),
      child: Column(
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
                  return Container(height: mediaHeight(context, 0.06));
                }
              },
                onEmpty: Container(height: mediaHeight(context, 0.06))
              )
            ],
          ),
          Text(comment.comment, style: CustomTextStyle.w500(context)),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CustomTextButton('좋아요 ${comment.commentLikeList.isEmpty ? '' : comment.commentLikeList.length}', (){
                      onLike(comment);
                    }, color: CustomColors.hint),
                    SizedBox(width: mediaWidth(context, 0.03)),
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
                      padding: EdgeInsets.all(mediaWidth(context, 0.033)),
                      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 20)
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: UserProfileCard(nestedComment.user)
                              ),
                              controller.obx((User? user){
                                if(nestedComment.user.nickname == user!.nickname) {
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
                          Container(
                            margin: baseVerticalPadding(context),
                            child: Row(
                              children: [
                                Expanded(child: Text(nestedComment.comment, style: CustomTextStyle.w500(context))),
                                Text(beforeDate(nestedComment.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint)),
                              ],
                            ),
                          ),
                        ],
                      )
                  )
              ]
          )
        ],
      ),
    );
  }
}
