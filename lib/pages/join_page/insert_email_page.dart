import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../widgets/text_fields/out_line_text_field.dart';

class InsertEmailPage extends StatefulWidget {
  TextEditingController email;
  TextEditingController password;
  TextEditingController passwordCheck;

  InsertEmailPage({
    required this.email,
    required this.password,
    required this.passwordCheck,
    Key? key}) : super(key: key);

  @override
  State<InsertEmailPage> createState() => _InsertEmailPageState();
}

class _InsertEmailPageState extends State<InsertEmailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(mediaWidth(context, 0.044)),
      child: Column(
        children: [
          OutlineTextField(
              controller: widget.email,
              hintText: '이메일',
              keyboardType: TextInputType.emailAddress
          ),
          OutlineTextField(
              controller: widget.password,
              obscureText: true,
              hintText: '비밀번호',
              margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
              keyboardType: TextInputType.visiblePassword
          ),
          OutlineTextField(
              controller: widget.passwordCheck,
              obscureText: true,
              hintText: '비밀번호 확인',
              keyboardType: TextInputType.visiblePassword
          ),
        ],
      ),
    );
  }
}
