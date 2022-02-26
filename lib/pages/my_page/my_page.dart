import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/auth/auth_controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../models/User.dart';
import '../login_page/login_page.dart';

class MyPage extends GetWidget<AuthController> {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx((User? user) => Scaffold(
      appBar: appBar(user!),
    ),
        onLoading: const CustomIndicator(),
        onError: (error) => CustomErrorView(error: error),
        onEmpty: const LoginPage()
    );
  }

  AppBar appBar(User user) => AppBar(
    title: Text(user.nickname ?? ''),
    actions: [
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: (){
          controller.logout();
        },
      )
    ],
  );
}
