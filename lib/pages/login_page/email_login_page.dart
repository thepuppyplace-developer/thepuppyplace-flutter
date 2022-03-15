import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/join_page/join_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/text_fields/out_line_text_field.dart';

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
      ),
    );
  }

  AppBar appBar() => AppBar(
    title: const Text('이메일로 로그인'),
  );
}
