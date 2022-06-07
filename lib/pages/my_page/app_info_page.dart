import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../controllers/version/version_controller.dart';
import '../../widgets/buttons/custom_text_button.dart';

class AppInfoPage extends StatelessWidget {
  static const String routeName = '/appInfoPage';
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: CustomTextStyle.appBarStyle(context),
        title: const Text('앱 정보')
      ),
      body: SingleChildScrollView(
        padding: basePadding(context),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: CustomTextButton('현재버전', null, color: Colors.black, alignment: Alignment.centerLeft)),
                GetBuilder<VersionController>(
                  init: VersionController(),
                  builder: (VersionController controller) => controller.obx((version) => Text(version!.version, style: CustomTextStyle.w500(context, color: CustomColors.hint))),
                )
              ],
            ),
            Row(
              children: [
                const Expanded(child: CustomTextButton('최신버전', null, color: Colors.black, alignment: Alignment.centerLeft)),
                GetBuilder<VersionController>(
                  init: VersionController(),
                  builder: (VersionController controller) => controller.obx((version) => Text(version!.version, style: CustomTextStyle.w500(context, color: CustomColors.hint))),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
