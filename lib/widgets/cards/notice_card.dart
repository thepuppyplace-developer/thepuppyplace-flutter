import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../models/Notice.dart';
import '../../pages/notice_page/notice_details_page.dart';

class NoticeCard extends StatelessWidget {
  final Notice notice;

  const NoticeCard(this.notice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Get.to(() => NoticeDetailsPage(notice), arguments: notice.id, routeName: '/noticeDetailsPage');
      },
      title: Container(
        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 20)
          ]
        ),
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
            Text(notice.notice_title, style: CustomTextStyle.w600(context, scale: 0.02), overflow: TextOverflow.ellipsis),
            Container(
              margin: EdgeInsets.only(top: mediaHeight(context, 0.02)),
              child: Text(beforeDate(notice.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint))
            )
          ],
        ),
      ),
    );
  }
}
