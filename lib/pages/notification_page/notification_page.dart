import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/controllers/notification/notification_log_list_controller.dart';
import 'package:thepuppyplace_flutter/widgets/loadings/sliver_contents.dart';

import '../../models/NotificationLog.dart';
import '../../util/common.dart';
import '../../widgets/cards/notification_log_card.dart';
import '../../widgets/loadings/refresh_contents.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationLogListController>(
      autoRemove: false,
      init: NotificationLogListController(context),
      builder: (NotificationLogListController controller) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, inner) => [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                title: Text('알림', style: CustomTextStyle.w600(context, scale: 0.02)),
              )
            ],
            body: Scrollbar(
              child: SmartRefresher(
                enablePullUp: controller.logList.isEmpty ? false : true,
                controller: controller.refreshController,
                onRefresh: () async{
                  controller.refreshLogList.whenComplete((){
                    controller.refreshController.refreshCompleted(resetFooterState: true);
                  });
                },
                onLoading: () async{
                  controller.getLogList.whenComplete((){
                    controller.refreshController.loadComplete();
                  });
                },
                header: CustomHeader(
                  builder: (BuildContext context, RefreshStatus? status) => RefreshContents(status),
                ),
                footer: controller.status.isEmpty ? null : CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus? status) => LoadContents(status),
                ),
                child: CustomScrollView(
                  slivers: [
                    controller.obx((logList) => SliverPadding(
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
            ),
          ),
        );
      }
    );
  }
}
