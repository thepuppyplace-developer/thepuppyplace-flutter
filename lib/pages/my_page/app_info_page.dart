import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';

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
              Container(
                constraints: BoxConstraints.expand(height: mediaHeight(context, 0.1)),
                margin: (baseHorizontalPadding(context) * 10).add(baseVerticalPadding(context) * 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(PngList.app_logo)
                    )
                  ),
              ),
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
                  const Expanded(child: CustomTextButton('개발', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text('황장우, 이지환', style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
              Row(
                children: [
                  const Expanded(child: CustomTextButton('디자인', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text('황영서', style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
              Row(
                children: [
                  const Expanded(child: CustomTextButton('기획', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text('김성은, 이하진, 이서진', style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
              Row(
                children: [
                  const Expanded(child: CustomTextButton('홍보', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text('유혜경, 김우식', style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
              Row(
                children: [
                  const Expanded(child: CustomTextButton('총괄', null, color: Colors.black, alignment: Alignment.centerLeft)),
                  Text('GlobalQ Korea', style: CustomTextStyle.w500(context, color: CustomColors.hint))
                ],
              ),
            ],
          ),
        ))
      ),
    );
  }
}
