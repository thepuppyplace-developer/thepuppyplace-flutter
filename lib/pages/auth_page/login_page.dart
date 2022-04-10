import 'package:email_validator/email_validator.dart';
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
  String _email = '';
  String _password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    UnderlineTextField(
                      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.03)),
                      onChanged: (String email){
                        setState(() {
                          _email = email;
                        });
                      },
                      validator: (String? email){
                        if(_email.isEmpty){
                          return '이메일을 입력해주세요.';
                        } else if(!EmailValidator.validate(_email)){
                          return '이메일 형식에 맞게 입력해주세요.';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      hintText: '이메일 아이디',
                    ),
                    UnderlineTextField(
                      onChanged: (String password){
                        setState(() {
                          _password = password;
                        });
                      },
                      validator: (String? password){
                        if(password!.isEmpty){
                          return '비밀번호를 입력해주세요.';
                        } else if(password.length < 8){
                          return '비밀번호를 8자 이상 입력해주세요.';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      hintText: '비밀번호',
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomButton(
                      title: '로그인',
                      textColor: Colors.white,
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          showIndicator(UserController.to.login(
                            email: _email.trim(),
                            password: _password.trim(),
                          ));
                        }
                      },
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
      ),
    );
  }
}
