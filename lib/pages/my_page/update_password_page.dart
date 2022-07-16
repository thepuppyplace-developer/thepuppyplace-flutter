import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/user/user_controller.dart';
import 'package:thepuppyplace_flutter/pages/my_page/update_my_page.dart';
import 'package:thepuppyplace_flutter/repositories/user/user_repository.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_text_button.dart';
import 'package:thepuppyplace_flutter/widgets/dialogs/custom_dialog.dart';

import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class UpdatePasswordPage extends StatefulWidget {
  static const String routeName = '/updatePasswordPage';
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
                        Container(
                          alignment: Alignment.centerRight,
                          child: CustomTextButton(
                            '비밀번호가 기억나지 않으세요?', () => showDialog(context: context, builder: (context) => CustomDialog(
                            title: '임시 비밀번호를 전송할까요?',
                            content: '임시 비밀번호를 전송하면 로그아웃됩니다.',
                            onTap: () => showIndicator(_sendPassword),
                          )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: CustomButton(
                    title: '변경하기',
                    onPressed: _beforePassword.length < 8 || _password.length < 8 || _passwordCheck.length < 8
                        ? null
                        : () {
                      if(_passwordKey.currentState!.validate()){
                        _passwordKey.currentState!.save();
                        showIndicator(_updatePassword);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  Future get _updatePassword async{
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

  Future get _sendPassword async{
    try{
      final int? statusCode = await _repo.sendPassword(context, UserController.user!.email!.trim());
      switch(statusCode){
        case 200:
          return UserController.to.logout(context);
        default:
          return network_check_message(context);
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }
}