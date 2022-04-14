import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../controllers/version/version_controller.dart';
import '../controllers/database/database_controller.dart';
import '../util/png_list.dart';
import 'navigator_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Get.put(DatabaseController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VersionController>(
      init: VersionController(),
      builder: (VersionController controller) {
        return controller.obx((version) => const NavigatorPage(),
          onEmpty: _updateView(),
          onError: (error) => CustomErrorView(error: error),
          onLoading: Scaffold(
              body: Image.asset(
                  PngList.splash,
                  height: mediaHeight(context, 1),
                  width: mediaWidth(context, 1),
                  fit: BoxFit.cover,
              )
          )
        );
      }
    );
  }

  Widget _updateView() => const Scaffold(
    body: Center(
      child: Text('업데이트를 해주세요.'),
    ),
  );
}
