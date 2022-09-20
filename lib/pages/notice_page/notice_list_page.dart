import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notice/notice_list_controller.dart';
import '../../models/Notice.dart';
import '../../util/common.dart';
import '../../util/custom_icons.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';
import '../../widgets/buttons/custom_icon_button.dart';
import '../../widgets/cards/notice_card.dart';
import 'notice_insert_page.dart';

class NoticeListPage extends StatelessWidget {
  static const String routeName = '/noticeListPage';
  const NoticeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<NoticeListController>(
      init: NoticeListController(),
      builder: (NoticeListController controller) {
        return Scaffold(
          body: NestedScrollView(
              headerSliverBuilder: (context, inner) => [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  pinned: true,
                  elevation: 0.5,
                  title: Text('공지사항', style: CustomTextStyle.w600(context, scale: 0.02)),
                  actions: !isAdmin
                      ? null
                      : [
                        CustomIconButton(
                          icon: CustomIcons.insert,
                          onTap: () => Get.toNamed(NoticeInsertPage.routeName)
                        )
                  ],
                )
              ],
              body: controller.obx((noticeList) => CustomScrollView(
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
              ),
                onLoading: const LoadingView(),
                onEmpty: const EmptyView(message: '등록된 공지사항이 없습니다.'),
                onError: (error) => EmptyView(message: error)
              )
          ),
        );
      }
  );
}
