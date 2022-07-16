import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user/user_controller.dart';
import '../../util/common.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

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
            title: Text('설정', style: CustomTextStyle.w600(context, scale: 0.02)),
          )
        ],
        body: GetBuilder<UserController>(
          init: UserController(),
          builder: (UserController controller) => controller.obx((user) => Container(
            margin: EdgeInsets.all(mediaWidth(context, 0.033)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: baseVerticalPadding(context) / 2,
                    child: Row(
                      children: [
                        Expanded(child: Text('서비스 알림 설정', style: CustomTextStyle.w500(context, scale: 0.02))),
                        CupertinoSwitch(value: user!.is_service_alarm, onChanged: (value){
                          controller.changeNotification(context, is_service_alarm: value);
                        })
                      ],
                    ),
                  ),
                  Container(
                    margin: baseVerticalPadding(context) / 2,
                    child: Row(
                      children: [
                        Expanded(child: Text('내 글 알림 설정', style: CustomTextStyle.w500(context, scale: 0.02))),
                        CupertinoSwitch(value: user.is_alarm, onChanged: (value){
                          controller.changeNotification(context, is_alarm: value);
                        })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ),
      ),
    );
  }
}
