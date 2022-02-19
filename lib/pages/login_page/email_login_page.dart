import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/auth/auth_controller.dart';
import 'package:thepuppyplace_flutter/pages/join_page/join_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons.dart';
import 'package:thepuppyplace_flutter/widgets/text_fields.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({Key? key}) : super(key: key);

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){unFocus(context);},
      child: Scaffold(
        appBar: appBar(),
        body: body(),
      ),
    );
  }

  AppBar appBar() => AppBar(
    title: const Text('이메일로 로그인'),
  );

  Widget body() => GetBuilder<AuthController>(
    builder: (AuthController controller) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(mediaWidth(context, 0.044)),
        child: Column(
          children: [
            OutlineTextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              hintText: '이메일',
            ),
            OutlineTextField(
              controller: _password,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
              hintText: '비밀번호',
            ),
            CustomButton(
                title: '로그인',
                onPressed: (){
                  controller.login(_email.text, _password.text);
                }),
            CupertinoFormRow(
              child: CustomTextButton(
                  title: '회원가입',
                  onPressed: (){
                    Get.to(() => const JoinPage(), fullscreenDialog: true);
                  }
              ),
            )
          ],
        ),
      );
    }
  );
}
