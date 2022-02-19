import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/customs.dart';
import 'package:thepuppyplace_flutter/widgets/buttons.dart';

import '../../util/svg_list.dart';
import 'email_login_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(context),
    );
  }

  AppBar appBar() => AppBar();

  Widget body(BuildContext context) => SafeArea(
    minimum: EdgeInsets.all(mediaWidth(context, 0.044)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('로그인 한번으로', style: CustomTextStyle.w400(context, scale: 0.03),),
            Text('The Puppy Place', style: CustomTextStyle.w600(context, scale: 0.03)),
            Text('서비스를 이용해보세요!😘', style: CustomTextStyle.w400(context, scale: 0.03),)
          ],
        ),
        Column(
          children: [
            LoginButton(
                title: '구글로 로그인',
                color: Colors.white,
                icon: SVGList.google,
                onPressed: (){}),
            LoginButton(
                title: '애플로 로그인',
                textColor: Colors.white,
                color: Colors.black,
                icon: SVGList.apple,
                iconColor: Colors.white,
                margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.012)),
                onPressed: (){}),
            LoginButton(
                title: '이메일로 로그인',
                icon: SVGList.email,
                onPressed: (){
                  Get.to(() => const EmailLoginPage(), fullscreenDialog: true);
                }),
          ],
        )
      ],
    ),
  );
}
