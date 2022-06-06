import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/cached_network_image_list.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';

import '../../util/common.dart';
import '../../util/custom_icons.dart';
import '../../widgets/buttons/custom_button.dart';

class LoginRequestPage extends StatelessWidget {
  const LoginRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              maxRadius: mediaHeight(context, 0.03),
              backgroundColor: CustomColors.hint,
              backgroundImage: AssetImage(PngList.app_logo),
            ),
            Text('로그인 후 이용해주세요', style: CustomTextStyle.w600(context, scale: 0.02, height: 3)),
            Container(
                margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
                child: Text('서비스를 이용하시기 위해\n로그인이 필요합니다.', style: CustomTextStyle.w400(context, scale: 0.018, color: Colors.grey), textAlign: TextAlign.center)),
            CustomButton(
              margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
              width: mediaWidth(context, 0.6),
              sideColor: CustomColors.main,
              color: Colors.white,
              textColor: CustomColors.main,
              title: '로그인 / 회원가입',
              onPressed: (){
                Get.toNamed('/loginPage');
              },
            )
          ],
        ),
      ),
    );
  }
}
