import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../controllers/version/version_controller.dart';
import 'navigator_page.dart';

class SplashPage extends GetWidget<VersionController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx((version) => const NavigatorPage(),
      onEmpty: _updateView(),
      onError: (error) => CustomErrorView(error: error),
      onLoading: const Scaffold(body: Center(child: Text('스플래쉬'),))
    );
  }

  Widget _updateView() => const Scaffold(
    body: Center(
      child: Text('업데이트를 해주세요.'),
    ),
  );
}
