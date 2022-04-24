import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/Notice.dart';
import '../../util/common.dart';

class NoticeDetailsPage extends StatelessWidget {
  final Notice notice;

  const NoticeDetailsPage(this.notice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, inner) => [
          SliverAppBar(
            snap: true,
            floating: true,
            pinned: true,
            elevation: 0.5,
            title: Text('공지사항', style: CustomTextStyle.w600(context, scale: 0.02)),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(mediaWidth(context, 0.033)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: mediaHeight(context, 0.01)),
                    padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.03), vertical: mediaHeight(context, 0.005)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(mediaHeight(context, 1)),
                        color: CustomColors.mainEmpty
                    ),
                    child: Text('공지사항', style: CustomTextStyle.w500(context, scale: 0.015, color: CustomColors.main)),
                  ),
                  Text(notice.notice_title, style: CustomTextStyle.w600(context, scale: 0.02)),
                  Container(
                      margin: EdgeInsets.only(top: mediaHeight(context, 0.02)),
                      child: Text(beforeDate(notice.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint))
                  )
                ],
              ),
            ),
          )
        ],
        body: Container(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 10)
              ]
          ),
          child: CustomScrollView(
            slivers: [
              if(notice.image_url != null)SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 3/2,
                  child: Container(
                    margin: EdgeInsets.only(bottom: mediaHeight(context, 0.02)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(notice.image_url!)
                      )
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Text(notice.notice_main_text, style: CustomTextStyle.w500(context)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
