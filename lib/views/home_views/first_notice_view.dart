import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/notice/notice_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/notice_page/notice_details_page.dart';
import '../../util/common.dart';

class FirstNoticeView extends StatelessWidget {
  const FirstNoticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoticeListController>(
      init: NoticeListController(context),
      builder: (NoticeListController controller) => SliverToBoxAdapter(
        child: controller.obx((noticeList) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(mediaHeight(context, 1)),
              border: Border.all(color: CustomColors.emptySide)
          ),
          margin: basePadding(context),
          child: CupertinoButton(
            padding: baseHorizontalPadding(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      style: CustomTextStyle.w500(context),
                      children: [
                        TextSpan(text: '공지사항 ', style: CustomTextStyle.w500(context, color: CustomColors.hint)),
                        TextSpan(text: noticeList!.first.notice_title)
                      ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            onPressed: () => Get.to(() => NoticeDetailsPage(noticeList.first)),
          ),
        ),
          onLoading: Container(),
          onError: (error) => Container(),
          onEmpty: Container()
        ),
      )
    );
  }
}
