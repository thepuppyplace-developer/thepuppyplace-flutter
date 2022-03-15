import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../controllers/user/user_controller.dart';
import '../../models/User.dart';
import 'login_request_page.dart';

class MyPage extends GetWidget<UserController> {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx((User? user) => Scaffold(
      appBar: appBar(user!),
    ),
        onLoading: const CustomIndicator(),
        onError: (error) => CustomErrorView(error: error),
        onEmpty: const LoginRequestPage()
    );
  }

  AppBar appBar(User user) => AppBar(
    title: Text(user.nickname ?? ''),
    actions: [
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: (){
        },
      )
    ],
  );
}
