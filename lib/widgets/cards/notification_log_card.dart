import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/models/NotificationLog.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class NotificationLogCard extends StatelessWidget {
  final NotificationLog notification;
  const NotificationLogCard(this.notification, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: mediaHeight(context, 0.01)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 10)
        ]
      ),
      child: CupertinoButton(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.log_body, style: CustomTextStyle.w600(context), overflow: TextOverflow.ellipsis, maxLines: 3),
            Container(
                margin: EdgeInsets.only(top: mediaWidth(context, 0.015)),
                child: Text(beforeDate(notification.createdAt), style: CustomTextStyle.w500(context, scale: 0.012, color: CustomColors.hint)))
          ],
        ),
        onPressed: (){
          Get.toNamed(BoardDetailsPage.routeName, arguments: RxInt(notification.log_action_id));
        },
      ),
    );
  }
}
