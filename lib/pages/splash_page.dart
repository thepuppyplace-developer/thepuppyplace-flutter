import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';
import '../../controllers/version/version_controller.dart';
import '../util/cached_network_image_list.dart';
import '../navigators/navigator_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VersionController>(
      init: VersionController(),
      builder: (VersionController controller) {
        return controller.obx((version) => const NavigatorPage(),
          onEmpty: _updateView(),
          onError: (error) => CustomErrorView(error: error),
          onLoading: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(PngList.splash)
                  )
                ),
              ),
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
