import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text_fields/under_line_text_field.dart';

class SignupInsertPage extends StatefulWidget {
  const SignupInsertPage({Key? key}) : super(key: key);

  @override
  _SignupInsertPageState createState() => _SignupInsertPageState();
}

class _SignupInsertPageState extends State<SignupInsertPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordCheck = TextEditingController();
  final TextEditingController _nickname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('필수 정보 입력', style: CustomTextStyle.w500(context, scale: 0.03)),
                      UnderlineTextField(
                        onChanged: (String email){

                        },
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        hintText: '이메일 주소 (아이디)',
                        margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.05)),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: UnderlineTextField(
                              onChanged: (String otp){

                              },
                              controller: _otp,
                              keyboardType: TextInputType.number,
                              hintText: '인증번호',
                              maxLength: 6,
                            ),
                          ),
                          CustomButton(
                            margin: EdgeInsets.only(left: mediaWidth(context, 0.03)),
                            title: '인증번호 전송',
                            color: Colors.white,
                            sideColor: CustomColors.emptySide,
                            textColor: Colors.black,
                            width: mediaWidth(context, 0.3),
                            onPressed: (){},
                          )
                        ],
                      ),
                      UnderlineTextField(
                        onChanged: (String password){

                        },
                        controller: _password,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: '비밀번호(8~20자 이내)',
                        maxLength: 20,
                        margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.05)),
                      ),
                      UnderlineTextField(
                        onChanged: (String password){

                        },
                        controller: _passwordCheck,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: '비밀번호 확인',
                        maxLength: 20,
                      ),
                      UnderlineTextField(
                        onChanged: (String nickname){

                        },
                        controller: _nickname,
                        keyboardType: TextInputType.text,
                        hintText: '닉네임',
                        maxLength: 16,
                        margin: EdgeInsets.only(top: mediaHeight(context, 0.05)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(
                title: '가입',
                height: mediaHeight(context, 0.06),
                margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                onPressed: (){}
            )
          ],
        ),
      ),
    );
  }
}
