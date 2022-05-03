import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/repositories/user/user_repository.dart';

import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _repo = UserRepository();

  final _passwordKey = GlobalKey<FormState>();
  String _beforePassword = '';
  String _password = '';
  String _passwordCheck = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, inner) => [
            SliverAppBar(
              snap: true,
              floating: true,
              pinned: true,
              title: Text('내 정보 수정', style: CustomTextStyle.w600(context, scale: 0.02)),
              elevation: 0.5,
            )
          ],
          body: Container(
            padding: EdgeInsets.all(mediaWidth(context, 0.033)),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _passwordKey,
                    child: Column(
                      children: [
                        Text('변경하실 새로운 비밀번호를 입력해주세요.', style: CustomTextStyle.w500(context, scale: 0.025), textAlign: TextAlign.center),
                        CustomTextField(
                          obscureText: true,
                          textFieldType: TextFieldType.underline,
                          keyboardType: TextInputType.visiblePassword,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: mediaHeight(context, 0.1)),
                          hintText: '비밀번호를 입력해주세요.',
                          onChanged: (String password){
                            setState(() {
                              _beforePassword = password;
                            });
                          },
                          validator: (String? password){
                            if(password!.isEmpty){
                              return '비밀번호가 입력되지 않았습니다.';
                            } else if(password.length < 8){
                              return '비밀번호를 8자 이상 입력해주세요.';
                            } else {
                              return null;
                            }
                          },
                        ),
                        CustomTextField(
                          obscureText: true,
                          textFieldType: TextFieldType.underline,
                          keyboardType: TextInputType.visiblePassword,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: mediaHeight(context, 0.01)),
                          hintText: '새로운 비밀번호를 입력해주세요.',
                          onChanged: (String password){
                            setState(() {
                              _password = password;
                            });
                          },
                          validator: (String? password){
                            if(password!.isEmpty){
                              return '비밀번호가 입력되지 않았습니다.';
                            } else if(password.length < 8){
                              return '비밀번호를 8자 이상 입력해주세요.';
                            } else {
                              return null;
                            }
                          },
                        ),
                        CustomTextField(
                          obscureText: true,
                          textFieldType: TextFieldType.underline,
                          keyboardType: TextInputType.visiblePassword,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: mediaHeight(context, 0.01)),
                          hintText: '새로운 비밀번호를 다시 한번 입력해주세요.',
                          onChanged: (String password){
                            setState(() {
                              _passwordCheck = password;
                            });
                          },
                          validator: (String? password){
                            if(password!.isEmpty){
                              return '비밀번호가 입력되지 않았습니다.';
                            } else if(password.length < 8){
                              return '비밀번호를 8자 이상 입력해주세요.';
                            } else if(password != _password){
                              return '비밀번호가 일치하지 않습니다.';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  title: '변경하기',
                  onPressed: _beforePassword.length < 8 || _password.length < 8 || _passwordCheck.length < 8
                      ? null
                      : () {
                    if(_passwordKey.currentState!.validate()){
                      _passwordKey.currentState!.save();
                      showIndicator(updatePassword);
                    }
                  },
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  Future get updatePassword async{
    int? statusCode = await _repo.updatePassword(
        context,
        before_password: _beforePassword,
        after_password: _password
    );
    if(statusCode == 200){
      return Get.back();
    } else if(statusCode == 403 || statusCode == 204) {
      return showSnackBar(context, '비밀번호가 일치하지 않습니다.');
    }
  }
}