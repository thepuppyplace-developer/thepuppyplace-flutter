import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
import 'package:thepuppyplace_flutter/widgets/dialogs/custom_dialog.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/BoardComment.dart';
import '../../models/NestedComment.dart';
import '../../models/Member.dart';
import '../../util/common.dart';
import '../buttons/custom_text_button.dart';
import 'user_profile_card.dart';

class CommentCard extends StatelessWidget {
  final BoardComment comment;
  final Function(BoardComment) onComment;
  final Function(NestedComment) onNestedComment;
  final Function(BoardComment) onLike;
  final Function() onCommentDelete;
  final Function(NestedComment) onNestedCommentDelete;
  final Function(NestNestComment) onNestNestCommentDelete;

  const CommentCard(this.comment, {
    required this.onComment,
    required this.onNestedComment,
    required this.onLike,
    required this.onCommentDelete,
    required this.onNestedCommentDelete,
    required this.onNestNestCommentDelete,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
      padding: EdgeInsets.all(mediaWidth(context, 0.033)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 5)
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
              if(compareMemberId(comment.userId)) CustomTextButton('삭제', (){
                showDialog(context: context, builder: (context) => CustomDialog(title: '댓글을 삭제하시겠습니까?', onTap: onCommentDelete));
              }, color: CustomColors.main, scale: 0.013)
            ],
          ),
          Text(comment.comment, style: CustomTextStyle.w500(context, scale: 0.015)),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if(comment.commentLikeList.where((like) => like.user_id == loginMemberId).isEmpty) CustomTextButton('좋아요 ${comment.commentLikeList.isEmpty ? '' : comment.commentLikeList.length}', (){
                      onLike(comment);
                    }, color: CustomColors.hint, scale: 0.013)
                    else CustomTextButton('좋아요 취소 ${comment.commentLikeList.isEmpty ? '' : comment.commentLikeList.length}', (){
                      onLike(comment);
                    }, color: CustomColors.main, scale: 0.013),

                    SizedBox(width: mediaWidth(context, 0.03)),
                    CustomTextButton('답글달기', (){
                      onComment(comment);
                    }, color: CustomColors.hint, scale: 0.013),
                  ],
                ),
              ),
              Text(beforeDate(comment.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint, scale: 0.013))
            ],
          ),
          if(comment.nestedCommentList.isNotEmpty) Column(
              children: [
                for(NestedComment nestedComment in comment.nestedCommentList)
                  _nestedComment(context, nestedComment)
              ]
          )
        ],
      ),
    );
  }

  Widget _nestedComment(BuildContext context, NestedComment nestedComment) => Container(
      padding: EdgeInsets.all(mediaWidth(context, 0.033)),
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 2)
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
              if(compareMemberId(nestedComment.user_id)) CustomTextButton(
                '삭제', () {
                showDialog(context: context, builder: (context) => CustomDialog(title: '댓글을 삭제하시겠습니까?', onTap: (){
                  onNestedCommentDelete(nestedComment);
                }));
              }, color: CustomColors.main, scale: 0.013,)
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: mediaWidth(context, 0.033)),
              child: Text(nestedComment.comment, style: CustomTextStyle.w500(context, scale: 0.015))),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CustomTextButton('답글달기', (){
                      onNestedComment(nestedComment);
                    }, color: CustomColors.hint, scale: 0.013),
                  ],
                ),
              ),
              Text(beforeDate(nestedComment.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint, scale: 0.013))
            ],
          ),
          for(NestNestComment nestNestComment in nestedComment.commentList) _nestNestComment(context, nestNestComment)
        ],
      )
  );

  Widget _nestNestComment(BuildContext context, NestNestComment nestNestComment) => Container(
      padding: EdgeInsets.all(mediaWidth(context, 0.033)),
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 2)
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: UserProfileCard(nestNestComment.user)
              ),
              if(compareMemberId(nestNestComment.user_id)) CustomTextButton(
                '삭제', () {
                showDialog(context: context, builder: (context) => CustomDialog(title: '댓글을 삭제하시겠습니까?', onTap: (){
                  onNestNestCommentDelete(nestNestComment);
                }));
              }, color: CustomColors.main, scale: 0.013,)
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(nestNestComment.comment, style: CustomTextStyle.w500(context, scale: 0.015))),
              Container(
                  margin: baseVerticalPadding(context),
                  child: Text(beforeDate(nestNestComment.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint, scale: 0.013))),
            ],
          ),
        ],
      )
  );
}
