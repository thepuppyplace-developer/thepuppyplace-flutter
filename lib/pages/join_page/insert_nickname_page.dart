import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/text_fields.dart';

class InsertNicknamePage extends StatelessWidget {
  TextEditingController nickname;

  InsertNicknamePage({
    required this.nickname,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(mediaWidth(context, 0.044)),
      child: Column(
        children: [
          OutlineTextField(
              controller: nickname,
              autofocus: true,
              hintText: '닉네임',
              keyboardType: TextInputType.text
          )
        ],
      ),
    );
  }
}
