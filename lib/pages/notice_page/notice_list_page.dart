import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/config.dart';
import '../../controllers/notice/notice_list_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Notice.dart';
import '../../util/common.dart';
import '../../util/custom_icons.dart';
import '../../util/customs.dart';
import '../../widgets/buttons/custom_icon_button.dart';
import '../../widgets/cards/notice_card.dart';
import 'notice_insert_page.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<NoticeListController>(
      init: NoticeListController(context),
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
                  actions: [
                    GetBuilder<UserController>(
                        init: UserController(),
                        builder: (UserController userCtr) => userCtr.obx((user){
                          switch(user!.email){
                            case Config.ADMIN_EMAIL:
                              return CustomIconButton(
                                icon: CustomIcons.insert,
                                onTap: (){
                                  Get.to(() => const NoticeInsertPage());
                                },
                              );
                            default: return Container();
                          }
                        })
                    )
                  ]
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
