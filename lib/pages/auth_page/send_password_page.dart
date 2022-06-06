import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/auth_page/login_page.dart';
import 'package:thepuppyplace_flutter/repositories/user/user_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_button.dart';
import 'package:thepuppyplace_flutter/widgets/text_fields/custom_text_field.dart';

class SendPasswordPage extends StatefulWidget {
  static const String routeName = '/sendPasswordPage';
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
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: basePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('비밀번호 재설정', style: CustomTextStyle.w500(context, scale: 0.03)),
              Container(
                  margin: baseVerticalPadding(context).copyWith(bottom: mediaHeight(context, 0.15)),
                  child: Text('가입 시 등록한 이메일 주소를 입력해주세요', style: CustomTextStyle.w500(context, color: CustomColors.hint))),
              Form(
                key: _emailKey,
                child: CustomTextField(
                  textFieldType: TextFieldType.underline,
                  onChanged: (email){
                    setState(() {
                      _email = email;
                    });
                  },
                  hintText: '이메일 주소',
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
            ],
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
      switch(statusCode){
        case 200:
          return Get.until((route) => route.settings.name == SendPasswordPage.routeName);
        case 204:
          return showSnackBar(context, '가입되어 있지 않은 이메일 주소입니다.');
      }
      return;
    }
  }
}
