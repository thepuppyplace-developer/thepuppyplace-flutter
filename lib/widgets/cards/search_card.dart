import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../models/Board.dart';
import '../../pages/board_page/board_details_page.dart';
import '../buttons/tag_text.dart';
import 'user_profile_card.dart';

class SearchBoardCard extends StatelessWidget {
  final Board board;
  const SearchBoardCard(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.all(mediaWidth(context, 0.033)),
        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: CustomColors.empty,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 10,
                  spreadRadius: 0.1
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserProfileCard(board.user!),
                      Row(
                        children: [
                          TagText(board.category, margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01))),
                          TagText(board.location, margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01))),
                        ],
                      ),
                      Text(board.title, style: CustomTextStyle.w600(context))
                    ],
                  ),
                ),
                if(board.board_photos!.isNotEmpty) Container(
                  height: mediaHeight(context, 0.1),
                  width: mediaHeight(context, 0.1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(board.board_photos!.first)
                      )
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onPressed: (){
        Get.to(() => BoardDetailsPage(board));
      },
    );
  }
}
