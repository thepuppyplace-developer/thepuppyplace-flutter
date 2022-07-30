import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/controllers/notification/notification_log_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/my_page/login_request_page.dart';
import 'package:thepuppyplace_flutter/widgets/loadings/sliver_contents.dart';

import '../../controllers/user/user_controller.dart';
import '../../models/NotificationLog.dart';
import '../../util/common.dart';
import '../../views/rx_status_view.dart';
import '../../widgets/cards/notification_log_card.dart';
import '../../widgets/loadings/refresh_contents.dart';

class NotificationPage extends GetWidget<UserController> {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, inner) => [
          SliverAppBar(
            elevation: 0.5,
            snap: true,
            floating: true,
            pinned: true,
            title: Text('알림', style: CustomTextStyle.appBarStyle(context)),
          )
        ],
        body: controller.obx((user) => GetBuilder<NotificationLogListController>(
            autoRemove: false,
            init: NotificationLogListController(),
            builder: (NotificationLogListController notificationCtr) {
              return Scrollbar(
                child: SmartRefresher(
                  enablePullUp: notificationCtr.logList.isNotEmpty,
                  controller: notificationCtr.refreshController,
                  onRefresh: () async{
                    notificationCtr.refreshLogList.whenComplete((){
                      notificationCtr.refreshController.refreshCompleted(resetFooterState: true);
                    });
                  },
                  onLoading: () async{
                    notificationCtr.getLogList.whenComplete((){
                      notificationCtr.refreshController.loadComplete();
                    });
                  },
                  header: CustomHeader(
                    builder: (BuildContext context, RefreshStatus? status) => RefreshContents(status),
                  ),
                  footer: notificationCtr.status.isEmpty ? null : CustomFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                    builder: (BuildContext context, LoadStatus? status) => LoadContents(status),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      notificationCtr.obx((logList) => SliverPadding(
                        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, index){
                            final NotificationLog log = logList![index];
                            return NotificationLogCard(log);
                          },
                              childCount: logList!.length
                          ),
                        ),
                      ),
                          onEmpty: const SliverEmpty('알람 로그가 없습니다.'),
                          onLoading: const SliverLoading(message: '알림 로그를 불러오고 있습니다.',)
                      )
                    ],
                  ),
                ),
              );
            }
        ),
            onEmpty: const LoginRequestPage(),
            onLoading: const LoadingView(message: '알림 목록을 불러오는 중입니다.')
        ),
      ),
    );
  }
}
