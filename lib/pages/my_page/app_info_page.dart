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
      body: GetBuilder<VersionController>(
        init: VersionController(),
        builder: (VersionController controller) => controller.obx((version) => SingleChildScrollView(
          padding: basePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: CustomTextButton('현재버전', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text(version!.currentVersion, style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
              Row(
                children: [
                  const Expanded(child: CustomTextButton('최신버전', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text(version.recentVersion, style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
              Row(
                children: [
                  const Expanded(child: CustomTextButton('개발자', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text('hpodong', style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
              Row(
                children: [
                  const Expanded(child: CustomTextButton('기획자', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text('hpodong', style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
            ],
          ),
        ))
      ),
    );
  }
}
