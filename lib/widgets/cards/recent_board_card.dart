import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/cards/user_profile_card.dart';
import '../../models/Board.dart';
import '../buttons/tag_text.dart';

class RecentBoardCard extends StatelessWidget {
  final Board board;
  const RecentBoardCard(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.all(mediaWidth(context, 0.033)),
        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurStyle: BlurStyle.outer, blurRadius: 2),
            ]
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: UserProfileCard(board.user),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TagText(board.category),
                        TagText(board.location)
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: mediaHeight(context, 0.01)),
                      child: Text(board.title, style: CustomTextStyle.w600(context), overflow: TextOverflow.ellipsis)),
                  Text(board.description, style: CustomTextStyle.w400(context, scale: 0.013), maxLines: 3, overflow: TextOverflow.ellipsis),
                  Builder(
                    builder: (context) {
                      if(board.board_photos.isEmpty){
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.02)),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.02)),
                          height: mediaHeight(context, 0.1),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(width: mediaWidth(context, 0.02),),
                            scrollDirection: Axis.horizontal,
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
                            ),
                          ),
                        );
                      }
                    }
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.heart, color: Colors.black54, size: mediaHeight(context, 0.022)),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.01)),
                            child: Text('${board.likeList.length}', style: CustomTextStyle.w400(context, scale: 0.012, color: Colors.black54))),
                        Icon(CupertinoIcons.chat_bubble_2, color: Colors.black54, size: mediaHeight(context, 0.022)),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.01)),
                            child: Text('${commentCount(board.commentList)}', style: CustomTextStyle.w400(context, scale: 0.012, color: Colors.black54))),
                      ],
                    ),
                  ),
                  Text(beforeDate(board.createdAt), style: CustomTextStyle.w500(context, scale: 0.012, color: CustomColors.hint))
                ],
              ),
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
