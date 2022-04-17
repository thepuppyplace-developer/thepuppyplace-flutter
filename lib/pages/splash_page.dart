import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../controllers/version/version_controller.dart';
import '../controllers/database/database_controller.dart';
import '../util/cached_network_image_list.dart';
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
              body: Container(
                height: mediaHeight(context, 1),
                width: mediaWidth(context, 1),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(CachedNetworkImageList.splash)
                  )
                ),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'The', style: CustomTextStyle.w500(context, scale: 0.03, fontFamily: 'Dongle')),
                          TextSpan(text: 'Puppy Place', style: CustomTextStyle.w600(context, scale: 0.03, fontFamily: 'Dongle')),
                        ]
                      ),
                    )
                  ],
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
