import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/tag_text.dart';
import '../../models/Board.dart';
import '../../models/User.dart';
import '../../util/svg_list.dart';

class BoardCard extends StatelessWidget {
  final Board board;

  const BoardCard(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = board.user!;
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
            Row(
              children: [
                CircleAvatar(radius: mediaHeight(context, 0.018)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.015)),
                    child: Text(user.nickname ?? '', style: CustomTextStyle.w600(context)))
              ],
            ),
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
            Container(
                margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.005)),
                child: Text(board.description, style: CustomTextStyle.w400(context, scale: 0.015), maxLines: 2, overflow: TextOverflow.ellipsis)),
            Builder(
              builder: (context){
                if(List.from(jsonDecode(board.photoList!)).isEmpty){
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)));
                } else {
                  return Container(
                    height: mediaHeight(context, 0.1),
                    margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02)),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(width: mediaWidth(context, 0.02)),
                      itemCount: List.from(jsonDecode(board.photoList!)).length,
                      itemBuilder: (context, index) => Container(
                        height: mediaHeight(context, 0.1),
                        width: mediaHeight(context, 0.1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    List.from(jsonDecode(board.photoList!))[index]
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
                  child: Wrap(
                    spacing: mediaWidth(context, 0.01),
                    children: [
                      SvgPicture.asset(SvgList.comment, height: 15),
                      Text('${board.commentList!.length}', style: CustomTextStyle.w500(context, scale: 0.02, color: CustomColors.hint)),
                    ],
                  ),
                ),
                Wrap(
                  spacing: mediaWidth(context, 0.01),
                  children: [
                    SvgPicture.asset(SvgList.clock, height: mediaHeight(context, 0.02)),
                    Text(beforeDate(board.createdAt ?? DateTime.now()), style: CustomTextStyle.w500(context, color: CustomColors.hint))
                  ],
                )
              ],
            )
          ],
        ),
      ),
      onPressed: (){},
    );
  }
}
