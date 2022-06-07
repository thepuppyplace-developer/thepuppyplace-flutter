import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/notice/notice_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/notice_page/notice_list_page.dart';
import '../../util/common.dart';

class FirstNoticeView extends StatelessWidget {
  const FirstNoticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoticeListController>(
      autoRemove: false,
      init: NoticeListController(context),
      builder: (NoticeListController controller) => SliverToBoxAdapter(
        child: controller.obx((noticeList) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(mediaHeight(context, 1)),
              border: Border.all(color: CustomColors.emptySide)
          ),
          margin: baseHorizontalPadding(context),
          child: CupertinoButton(
            padding: baseHorizontalPadding(context),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.speaker, color: Colors.black, size: mediaHeight(context, 0.025),),
                    Text('공지사항 ', style: CustomTextStyle.w500(context, color: CustomColors.hint)),
                  ],
                ),
                Expanded(
                  child: Text(noticeList!.first.notice_title, style: CustomTextStyle.w500(context), overflow: TextOverflow.ellipsis,)
                ),
              ],
            ),
            onPressed: () => Get.toNamed(NoticeListPage.routeName),
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
