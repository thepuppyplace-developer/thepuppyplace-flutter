import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/controllers/user/user_controller.dart';
import 'package:thepuppyplace_flutter/repositories/user_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class SignupInsertPage extends StatefulWidget {
  const SignupInsertPage({Key? key}) : super(key: key);

  @override
  _SignupInsertPageState createState() => _SignupInsertPageState();
}

class _SignupInsertPageState extends State<SignupInsertPage> {
  final UserRepository _repository = UserRepository();

  String _email = '';
  String _password = '';
  String _passwordCheck = '';
  String _otp = '';
  String _nickname = '';
  String? _authNumber;

  String? _emailValidator;
  String? _nicknameValidator;

  final GlobalKey<FormState> _otpKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nicknameKey = GlobalKey<FormState>();

  bool _sendOTP = false;
  bool _auth = false;

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
                      Form(
                        key: _emailKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.05)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  textFieldType: TextFieldType.underline,
                                  onChanged: (String email){
                                    setState(() {
                                      _email = email;
                                    });
                                  },
                                  enabled: _authNumber == null,
                                  fillColor: _authNumber == null ? null : CustomColors.emptySide,
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: '이메일 주소 (아이디)',
                                  helperText: !_auth ? null : '인증되었습니다.',
                                  helperColor: CustomColors.main,
                                  validator: (String? email){
                                    if(email!.isEmpty){
                                      return '이메일 주소를 입력해주세요.';
                                    } else if(!EmailValidator.validate(email)){
                                      return '이메일 주소 형식에 맞게 입력해주세요.';
                                    } else if(_emailValidator != null){
                                      return _emailValidator;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              CustomButton(
                                margin: EdgeInsets.only(left: mediaWidth(context, 0.03)),
                                title: _authNumber != null ? '인증번호 재전송' : '인증번호 전송',
                                color: Colors.white,
                                sideColor: _authNumber != null ? CustomColors.main : CustomColors.emptySide,
                                textColor: _authNumber != null ? CustomColors.main : Colors.black,
                                height: mediaHeight(context, 0.055),
                                width: mediaWidth(context, 0.3),
                                onPressed: () async{
                                  _emailValidator = await _repository.emailCheck(context, _email);
                                  if(_emailKey.currentState!.validate()){
                                    _emailKey.currentState!.save();
                                    _authNumber = await _repository.sendOTP(context, _email);
                                    setState(() {
                                      _sendOTP = _authNumber != null;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        crossFadeState: _authNumber == null || _auth
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 500),
                        firstChild: Container(),
                        secondChild: Form(
                          key: _otpKey,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  textFieldType: TextFieldType.underline,
                                  onChanged: (String otp){
                                    setState(() {
                                      _otp = otp;
                                    });
                                  },
                                  validator: (String? otp){
                                    if(otp!.length < 6){
                                      return '인증번호를 6자 이상 입력해주세요.';
                                    } else if(otp != _authNumber){
                                      return '인증번호가 일치하지 않습니다.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  contentPadding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
                                  keyboardType: TextInputType.number,
                                  hintText: '인증번호',
                                  maxLength: 6,
                                  helperText: _sendOTP ? '인증번호가 전송되었습니다.' : null,
                                  helperColor: CustomColors.main,
                                  margin: EdgeInsets.only(bottom: mediaHeight(context, 0.05)),
                                ),
                              ),
                              CustomButton(
                                margin: EdgeInsets.only(left: mediaWidth(context, 0.03)),
                                title: '인증번호 확인',
                                color: Colors.white,
                                sideColor: CustomColors.main,
                                textColor: CustomColors.main,
                                height: mediaHeight(context, 0.055),
                                width: mediaWidth(context, 0.3),
                                onPressed: () async{
                                  if(_otpKey.currentState!.validate()){
                                    _otpKey.currentState!.save();
                                    _emailValidator = await _repository.emailCheck(context, _email);
                                    setState(() {
                                      _auth = true;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ),
                      Form(
                        key: _passwordKey,
                        child: Column(
                          children: [
                            CustomTextField(
                                textFieldType: TextFieldType.underline,
                                onChanged: (String password){
                                setState(() {
                                  _password = password;
                                });
                              },
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                hintText: '비밀번호(8~20자 이내)',
                                maxLength: 20,
                                margin: EdgeInsets.only(bottom: mediaHeight(context, 0.05))
                            ),
                            CustomTextField(
                              textFieldType: TextFieldType.underline,
                              onChanged: (String password){
                                setState(() {
                                  _passwordCheck = password;
                                });
                              },
                              validator: (String? password){
                                if(password != _password){
                                  return '비밀번호가 일치하지 않습니다.';
                                } else {
                                  return null;
                                }
                              },
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              hintText: '비밀번호 확인',
                              maxLength: 20,
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _nicknameKey,
                        child: CustomTextField(
                          textFieldType: TextFieldType.underline,
                          onChanged: (String nickname){
                            setState(() {
                              _nickname = nickname;
                            });
                          },
                          validator: (String? nickname){
                            if(nickname!.length < 6){
                              return '닉네임을 6자 이상 입력해주세요.';
                            } else if(_nicknameValidator != null){
                              return _nicknameValidator;
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          hintText: '닉네임',
                          maxLength: 16,
                          margin: EdgeInsets.only(top: mediaHeight(context, 0.05)),
                        ),
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
                onPressed: !_auth || _password.length < 8 || _passwordCheck.length < 8 || _nickname.length < 6 ? null : () async{
                  _nicknameValidator = await _repository.nicknameCheck(_nickname);
                  if(_passwordKey.currentState!.validate()){
                    _passwordKey.currentState!.save();
                    if(_nicknameKey.currentState!.validate()){
                      _nicknameKey.currentState!.save();
                      showIndicator(UserController.to.signup(context, email: _email, password: _password, passwordCheck: _passwordCheck, nickname: _nickname));;
                    }
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
