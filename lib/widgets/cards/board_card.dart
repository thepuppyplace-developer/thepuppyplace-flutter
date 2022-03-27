import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/tag_text.dart';

import '../../models/Board.dart';
import '../../util/png_list.dart';
import '../../util/svg_list.dart';

class BoardCard extends StatelessWidget {
  final Board board;

  const BoardCard(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(mediaWidth(context, 0.033)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(board.photoList.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CarouselSlider.builder(
              itemCount: board.photoList.length,
              options: CarouselOptions(),
              itemBuilder: (context, index, index2) => Image.network(board.photoList[index]),
            )
          ),
          Row(
            children: board.tagList.map((String text) => TagText(text)).toList(),
          ),
          Text(board.title, style: CustomTextStyle.w600(context, scale: 0.022, height: 2), overflow: TextOverflow.ellipsis),
          Text(board.description, style: CustomTextStyle.w400(context, scale: 0.018), maxLines: 2, overflow: TextOverflow.ellipsis),
          Container(
            margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.05)),
            child: Wrap(
              spacing: mediaWidth(context, 0.05),
              children: [
                Wrap(
                  spacing: mediaWidth(context, 0.005),
                  children: [
                    SvgPicture.asset(SvgList.comment, height: 15),
                    Text(board.commentList == null ? '0' : '${board.commentList!.length}', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.hint)),
                  ],
                ),
                Wrap(
                  spacing: mediaWidth(context, 0.005),
                  children: [
                    SvgPicture.asset(SvgList.clock, height: 15),
                    Text(beforeDate(board.createdAt ?? DateTime.now()), style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.hint))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
