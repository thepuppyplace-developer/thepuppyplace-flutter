import 'package:flutter/material.dart';
import '../../models/BoardComment.dart';
import '../../models/NestedComment.dart';
import '../../util/common.dart';
import '../buttons/custom_text_button.dart';
import 'user_profile_card.dart';

class CommentCard extends StatelessWidget {
  final BoardComment comment;

  const CommentCard(this.comment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: UserProfileCard(comment.user!)
            ),
            CustomTextButton('삭제', (){})
          ],
        ),
        Text(comment.comment, style: CustomTextStyle.w500(context)),
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
            Text(beforeDate(comment.createdAt ?? DateTime.now()), style: CustomTextStyle.w500(context, color: CustomColors.hint))
          ],
        ),
        if(comment.nestedCommentList!.isNotEmpty) Column(
          children: [
            for(NestedComment nestedComment in comment.nestedCommentList!)
              Container(
                margin: EdgeInsets.only(left: mediaWidth(context, 0.05)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: UserProfileCard(comment.user!)
                        ),
                        CustomTextButton('삭제', (){})
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
                        Text(beforeDate(comment.createdAt ?? DateTime.now()), style: CustomTextStyle.w500(context, color: CustomColors.hint))
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
