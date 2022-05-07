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
    return Container(
      margin: EdgeInsets.only(bottom: mediaWidth(context, 0.033)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: CustomColors.emptySide,
                blurStyle: BlurStyle.outer,
                blurRadius: 10,
            )
          ]
      ),
      child: CupertinoButton(
        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserProfileCard(board.user),
                      Row(
                        children: [
                          TagText(board.category, margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01))),
                          TagText(board.location, margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01))),
                        ],
                      ),
                      Text(board.title, style: CustomTextStyle.w600(context), overflow: TextOverflow.ellipsis)
                    ],
                  ),
                ),
                if(board.board_photos.isNotEmpty) Container(
                  alignment: Alignment.center,
                  height: mediaHeight(context, 0.1),
                  width: mediaHeight(context, 0.1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        opacity: board.board_photos.isEmpty ? 1 : 0.5,
                          colorFilter: board.board_photos.isEmpty ? null : const ColorFilter.mode(Colors.black, BlendMode.colorDodge),
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(board.board_photos.first)
                      )
                  ),
                  child: Text('+ ${board.board_photos.length - 1}', style: CustomTextStyle.w500(context, color: Colors.white, scale: 0.02)),
                )
              ],
            )
          ],
        ),
        onPressed: (){
          Get.toNamed(BoardDetailsPage.routeName, arguments: board.id);
        },
      ),
    );
  }
}
