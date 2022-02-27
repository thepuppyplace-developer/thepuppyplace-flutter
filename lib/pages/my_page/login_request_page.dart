import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../login_page/login_page.dart';

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
            CircleAvatar(),
            Text('로그인 후 이용해주세요', style: CustomTextStyle.w600(context, scale: 0.025, height: 3)),
            Text('로그인 한번으로\nThe Puppy Place를\n이용해보세요.', style: CustomTextStyle.w400(context, scale: 0.018, height: 1.3), textAlign: TextAlign.center),
            CustomButton(
              margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
              width: mediaWidth(context, 0.6),
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
