import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user/user_controller.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/text_fields/under_line_text_field.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: 'the ', style: CustomTextStyle.w500(context, fontFamily: 'Dongle', scale: 0.04)),
                  TextSpan(text: 'puppy place', style: CustomTextStyle.w600(context, scale: 0.04, fontFamily: 'Dongle')),
                ]
            ),
          ),
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(Icons.clear, color: Colors.black),
              onPressed: (){
                Get.back();
              },
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.055)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  UnderlineTextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: '이메일 아이디',
                  ),
                  UnderlineTextField(
                    controller: _password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    hintText: '비밀번호',
                  ),
                ],
              ),
              Column(
                children: [
                  GetBuilder<UserController>(
                      builder: (UserController controller) {
                        return CustomButton(
                          title: '로그인',
                          textColor: Colors.white,
                          onPressed: (){
                            showIndicator(
                                future: controller.login(
                                    email: _email.text.trim(),
                                    password: _password.text.trim()
                                ),
                                text: '로그인 중입니다...'
                            );
                          },
                        );
                      }
                  ),
                  CustomButton(
                    margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
                    color: Colors.white,
                    sideColor: CustomColors.main,
                    title: '회원가입',
                    textColor: CustomColors.main,
                    onPressed: (){
                      Get.to(() => const SignupPage());
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextButton('아이디 찾기', (){}, color: CustomColors.hint),
                      VerticalDivider(color: CustomColors.hint, width: mediaWidth(context, 0.1)),
                      CustomTextButton('비밀번호 재설정', (){}, color: CustomColors.hint),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Text('다른 SNS로 로그인', style: CustomTextStyle.w500(context, scale: 0.018)),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
