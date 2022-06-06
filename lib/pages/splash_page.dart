import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
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
                padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.1)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(CachedNetworkImageList.splash)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'The ', style: CustomTextStyle.w500(context, scale: 0.08, color: Colors.white, fontFamily: 'Dongle')),
                          TextSpan(text: 'Puppy Place', style: CustomTextStyle.w600(context, scale: 0.08, color: Colors.white, fontFamily: 'Dongle')),
                        ]
                      ),
                    ),
                    Text('강아지들과 함께 갈 수 있는\n대한민국 모든 곳!',
                      style: CustomTextStyle.w500(context, color: Colors.white, scale: 0.025, height: 2),
                      textAlign: TextAlign.center,
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
