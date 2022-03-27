import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../models/Board.dart';
import '../../util/png_list.dart';
import '../../util/svg_list.dart';
import '../buttons/tag_text.dart';

class RecentBoardCard extends StatelessWidget {
  final Board board;
  const RecentBoardCard(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: board.photoList.isEmpty
              ? Image.asset(PngList.splash, height: mediaHeight(context, 0.13), width: mediaWidth(context, 1), fit: BoxFit.cover)
              : Image.network(board.photoList.first),
        ),
        if(board.tagList.isNotEmpty) Row(
          children: board.tagList.map((text) => TagText(text)).toList(),
        ),
        Text(board.title, style: CustomTextStyle.w600(context, scale: 0.022), overflow: TextOverflow.ellipsis),
        Container(
          margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
          child: Wrap(
            spacing: mediaWidth(context, 0.01),
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SvgPicture.asset(SvgList.comment, height: mediaHeight(context, 0.015)),
              Text(board.commentList != null && board.commentList!.isNotEmpty ? '${board.commentList!.length}' : '0', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.hint))
            ],
          ),
        )
      ],
    );
  }
}
