import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/tag_text.dart';
import 'package:thepuppyplace_flutter/widgets/cards/user_profile_card.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';

import '../../models/Board.dart';

class BestBoardCard extends StatefulWidget {
  final Board board;

  const BestBoardCard(this.board, {Key? key}) : super(key: key);

  @override
  State<BestBoardCard> createState() => _BestBoardCardState();
}

class _BestBoardCardState extends State<BestBoardCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
                  UserProfileCard(widget.board.user),
                  Container(
                    margin: baseVerticalPadding(context) / 2,
                    child: Row(
                      children: [
                        TagText(widget.board.category),
                        TagText(widget.board.location),
                      ],
                    ),
                  ),
                  Text(widget.board.title, style: CustomTextStyle.w600(context), overflow: TextOverflow.ellipsis)
                ],
              ),
            ),
            if(widget.board.board_photos.isNotEmpty) Stack(
              alignment: Alignment.center,
              children: [
                CustomCachedNetworkImage(
                  widget.board.board_photos.first,
                  opacity: widget.board.board_photos.length > 1 ? 0.5 : 0.0,
                  height: mediaHeight(context, 0.06),
                  width: mediaHeight(context, 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                if(widget.board.board_photos.length > 1) Text('+${widget.board.board_photos.length - 1}', style: CustomTextStyle.w500(context, color: Colors.white),)
              ],
            )
          ],
        ),
        onPressed: (){
          Get.toNamed(BoardDetailsPage.routeName, arguments: RxInt(widget.board.id));
        },
      ),
    );
  }
}
