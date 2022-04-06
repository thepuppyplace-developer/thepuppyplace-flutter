import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_check_button.dart';
import 'signup_insert_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  List<bool> checkList = <bool>[false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.05)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('회원가입', style: CustomTextStyle.w500(context, scale: 0.03)),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
                        child: Text('서비스 가입을 위해 약관동의가 필요해요.', style: CustomTextStyle.w500(context, scale: 0.018, color: CustomColors.hint))),
                    CustomCheckButtonItem(
                      child: Text('아래 내용에 모두 동의합니다.', style: CustomTextStyle.w600(context, scale: 0.02, color: checkList[1] ? CustomColors.main : Colors.black)),
                      side: true,
                      onTap: (bool value){
                        setState(() {
                          checkList[1] = value;
                        });
                      },
                      value: checkList[1],
                    )
                  ],
                ),
              ),
            ),
          ),
          CustomButton(
            title: '다음',
            margin: EdgeInsets.all(mediaWidth(context, 0.033)),
            height: mediaHeight(context, 0.06),
            onPressed: (){
              Get.to(() => const SignupInsertPage());
            },
          )
        ],
      )
    );
  }
}
