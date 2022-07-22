import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/tag_text.dart';
import 'package:thepuppyplace_flutter/widgets/cards/user_profile_card.dart';

import '../../models/Board.dart';

class BestBoardCard extends StatelessWidget {
  final Board board;

  const BestBoardCard(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)).copyWith(bottom: mediaHeight(context, 0.02)),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 10)
        ]
      ),
      child: CupertinoButton(
        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProfileCard(board.user),
                  Container(
                    margin: baseVerticalPadding(context) / 2,
                    child: Row(
                      children: [
                        TagText(board.category),
                        TagText(board.location),
                      ],
                    ),
                  ),
                  Text(board.title, style: CustomTextStyle.w600(context), overflow: TextOverflow.ellipsis)
                ],
              ),
            ),
            if(board.board_photos.isNotEmpty) Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(board.board_photos.first)
                )
              ),
            )
          ],
        ),
        onPressed: (){
          Get.toNamed(BoardDetailsPage.routeName, arguments: RxInt(board.id));
        },
      ),
    );
  }
}
