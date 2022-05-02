import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/repositories/user/user_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_button.dart';
import 'package:thepuppyplace_flutter/widgets/text_fields/custom_text_field.dart';

class SendPasswordPage extends StatefulWidget {
  const SendPasswordPage({Key? key}) : super(key: key);

  @override
  State<SendPasswordPage> createState() => _SendPasswordPageState();
}

class _SendPasswordPageState extends State<SendPasswordPage> {

  final _repo = UserRepository();

  final _emailKey = GlobalKey<FormState>();

  String _email = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('비밀번호 재설정', style: CustomTextStyle.w600(context, scale: 0.02)),
        ),
        body: Form(
          key: _emailKey,
          child: CustomTextField(
            margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
            textFieldType: TextFieldType.underline,
            onChanged: (email){
              setState(() {
                _email = email;
              });
            },
            hintText: '이메일을 입력해주세요.',
            validator: (email){
              if(email!.isEmpty){
                return '이메일이 입력되지 않았습니다.';
              } else if(!EmailValidator.validate(email)){
                return '이메일 형식에 맞게 입력해주세요.';
              } else {
                return null;
              }
            },
          ),
        ),
        floatingActionButton: CustomButton(
            title: '전송',
            margin: EdgeInsets.all(mediaWidth(context, 0.033)),
            onPressed: () {
              showIndicator(sendPassword);
            }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future get sendPassword async{
    if(_emailKey.currentState!.validate()){
      _emailKey.currentState!.save();
      int? statusCode = await _repo.sendPassword(context, _email);
      if(statusCode == 200){
        Get.until((route) => route.isFirst);
      }
      return;
    }
  }
}
