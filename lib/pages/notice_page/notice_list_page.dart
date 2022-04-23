import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notice/notice_controller.dart';
import '../../models/Notice.dart';
import '../../util/common.dart';
import '../../widgets/cards/notice_card.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: NestedScrollView(
      headerSliverBuilder: (context, inner) => [
        SliverAppBar(
          title: Text('공지사항', style: CustomTextStyle.w600(context, scale: 0.02)),
        )
      ],
      body: GetBuilder<NoticeListController>(
        init: NoticeListController(context),
        builder: (NoticeListController controller) => controller.obx((noticeList) => CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index){
                final Notice notice = noticeList![index];
                return NoticeCard(notice);
              },
                  childCount: noticeList!.length
              ),
            )
          ],
        ))
      ),
    ),
  );
}
