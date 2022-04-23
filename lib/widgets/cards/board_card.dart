import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/tag_text.dart';
import '../../models/Board.dart';
import '../../util/custom_icons.dart';
import 'user_profile_card.dart';

class BoardCard extends StatelessWidget {
  final Board board;

  const BoardCard(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 5)
            ]
        ),
        margin: EdgeInsets.all(mediaWidth(context, 0.033)),
        width: mediaWidth(context, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileCard(board.user),
            Container(
              margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.005)),
              child: Row(
                children: [
                  TagText(board.category),
                  TagText(board.location)
                ],
              ),
            ),
            Text(board.title, style: CustomTextStyle.w600(context, scale: 0.018), overflow: TextOverflow.ellipsis),
            Text(board.view_count.toString()),
            Container(
                margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.005)),
                child: Text(board.description, style: CustomTextStyle.w400(context, scale: 0.015), maxLines: 2, overflow: TextOverflow.ellipsis)),
            Builder(
              builder: (context){
                if(board.board_photos.isEmpty){
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)));
                } else {
                  return Container(
                    height: mediaHeight(context, 0.1),
                    margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(width: mediaWidth(context, 0.02)),
                      itemCount: board.board_photos.length,
                      itemBuilder: (context, index) => Container(
                        height: mediaHeight(context, 0.1),
                        width: mediaHeight(context, 0.1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    board.board_photos[index]
                                ),
                                fit: BoxFit.cover
                            )
                        ),
                      )
                    ),
                  );
                }
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(CustomIcons.heart, color: CustomColors.hint, size: mediaHeight(context, 0.02)),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.015)).copyWith(right: mediaWidth(context, 0.05)),
                          child: Text(board.likeList.length.toString(), style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.hint))),
                      Icon(CustomIcons.comment, color: CustomColors.hint, size: mediaHeight(context, 0.02)),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.015)),
                          child: Text('${commentCount(board.commentList)}', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.hint))),
                    ],
                  ),
                ),
                Wrap(
                  spacing: mediaWidth(context, 0.01),
                  children: [
                    Icon(CustomIcons.clock, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                    Text(beforeDate(board.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint))
                  ],
                )
              ],
            )
          ],
        ),
      ),
      onPressed: (){
        Get.to(() => BoardDetailsPage(board.id));
      },
    );
  }
}
