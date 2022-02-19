import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/login_page/login_page.dart';
import 'package:thepuppyplace_flutter/pages/navigator_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../controllers/auth/auth_controller.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (AuthController controller) {
        return controller.obx((user) => const NavigatorPage(),
          onLoading: const CustomIndicator(),
          onError: (error) => CustomErrorView(error: error),
          onEmpty: const LoginPage()
        );
      }
    );
  }
}
