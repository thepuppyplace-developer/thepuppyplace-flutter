import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thepuppyplace_flutter/controllers/user/user_controller.dart';
import 'package:thepuppyplace_flutter/repositories/user/user_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../models/Term.dart';
import '../../util/utf8_length_limiting_text_input_formatter.dart';
import '../../util/validations.dart';
import '../../widgets/animations/text_timer.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/dialogs/custom_dialog.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class SignupInsertPage extends StatefulWidget {
  final GoogleSignInAccount? googleUser;
  final AuthorizationCredentialAppleID? appleUser;
  final List<Term> termsList;
  const SignupInsertPage({this.googleUser, this.appleUser, required this.termsList, Key? key}) : super(key: key);

  @override
  _SignupInsertPageState createState() => _SignupInsertPageState();
}

class _SignupInsertPageState extends State<SignupInsertPage> {
  final UserRepository _userRepo = UserRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpKey = GlobalKey<FormState>();

  String? _emailValidator;
  String? _nicknameValidator;

  String _email = '';
  String _password = '';
  String _passwordCheck = '';
  String _otp = '';
  String? _otpNumber;
  String _nickname = '';

  String? _otpValidator;

  bool _verificationOTP = false;

  Future<void> _sendOTP(String email) async{
    if(_emailKey.currentState!.validate()){
      setState(() {
        _emailKey.currentState?.save();
        _otpValidator = null;
        _verificationOTP = false;
        _otpNumber = null;
      });
      _otpNumber = await _userRepo.sendOTP(email).whenComplete(() => setState((){}));
    }
  }

  void _changeEmail(){
    Get.back();
    setState(() {
      _otpNumber = null;
      _verificationOTP = false;
    });
  }

  void _verification(String otp){
    if(_otpKey.currentState!.validate()){
      _otpKey.currentState?.save();
      setState(() {
        _otpValidator = null;
        _verificationOTP = true;
      });
      showSnackBar(context, '이메일 인증에 성공하였습니다.');
    }
  }

  Future<String?> _emailCheck(String email) async{
    final int? statusCode = await _userRepo.emailCheck(email);
    switch(statusCode){
      case 200: return null;
      case 401: return '사용할 수 없는 이메일 주소입니다.';
      default: return '알 수 없는 오류가 발생했습니다.';
    }
  }

  Future<String?> _nicknameCheck(String nickname) async{
    final int? statusCode = await _userRepo.nicknameCheck(nickname);
    switch(statusCode){
      case 200: return null;
      case 401: return '사용할 수 없는 닉네임입니다.';
      default: return '알 수 없는 오류가 발생했습니다.';
    }
  }

  Future _signup() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      if(_allVerification){
        final int? statusCode = await UserController.to.signup(widget.termsList, email: _email, password: _password, nickname: _nickname);
        switch(statusCode){
          case 201:
            await showSnackBar(context, '환영합니다.');
            return Get.until((route) => route.isFirst);
          default:
            await network_check_message(context);
            return;
        }
      }
    }
  }

  bool get _allVerification => _verificationOTP
      && Validations.nickname(_nickname, validator: _nicknameValidator) == null
      && Validations.email(_email, validator: _emailValidator) == null
      && Validations.password(_password) == null;

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
              Container(
                  margin: EdgeInsets.only(bottom: mediaHeight(context, 0.07)),
                  child: Text('필수 정보 입력', style: CustomTextStyle.w500(context, scale: 0.025))),
              Form(
                key: _emailKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: CustomTextField(
                          autofocus: true,
                          autoValidateMode: !EmailValidator.validate(_email) ? null : AutovalidateMode.onUserInteraction,
                          textFieldType: TextFieldType.underline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.send,
                          hintText: '이메일',
                          validator: (email) => Validations.email(email, validator: _emailValidator),
                          onChanged: (email) async{
                            _email = email;
                            if(EmailValidator.validate(email)){
                              _emailValidator = await _emailCheck(email);
                            }
                            setState(() {});
                          },
                          onFieldSubmitted: (email){
                            showIndicator(_sendOTP(email));
                          },
                          enabled: _otpNumber == null,
                          fillColor: _otpNumber == null ? null : CustomColors.emptySide,
                        ),
                        onPressed: _otpNumber == null ? null : (){
                          showDialog(context: context, builder: (context) => CustomDialog(title: '이메일 주소를 변경하시겠습니까?', onTap: _changeEmail));
                        },
                      ),
                    ),
                    CustomButton(
                        borderRadius: 5,
                        height: mediaHeight(context, 0.055),
                        margin: EdgeInsets.only(left: mediaWidth(context, 0.033)),
                        sideColor: _otpNumber != null ? CustomColors.main : Colors.black,
                        textColor: _otpNumber != null ? CustomColors.main : Colors.black,
                        color: Colors.white,
                        disabledColor: CustomColors.emptySide,
                        width: mediaWidth(context, 0.3),
                        title: _otpNumber != null ? _verificationOTP ? '변경' : '재전송' : '인증번호 전송',
                        onPressed: (){
                          if(_verificationOTP){
                            showDialog(context: context, builder: (context) => CustomDialog(title: '이메일 주소를 변경하시겠습니까?', onTap: _changeEmail));
                          } else {
                            showIndicator(_sendOTP(_email));
                          }
                        }
                    ),
                  ],
                ),
              ),
              if(_otpNumber != null && !_verificationOTP) Form(
                key: _otpKey,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  margin: EdgeInsets.only(top: mediaWidth(context, 0.033)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.passthrough,
                          alignment: Alignment.centerRight,
                          children: [
                            CustomTextField(
                              textFieldType: TextFieldType.underline,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                              onFieldSubmitted: _verification,
                              hintText: '인증번호',
                              validator: (otp){
                                if(_otpValidator != null){
                                  return _otpValidator;
                                } else if(otp!.isEmpty){
                                  return '인증번호를 입력해주세요.';
                                } else if(otp.length < 6){
                                  return '인증번호 6자를 입력해주세요.';
                                } else if(otp != _otpNumber){
                                  return '인증번호가 일치하지 않습니다.';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (otp) => setState(() => _otp = otp),
                              suffixIcon: TextTimer(
                                margin: baseHorizontalPadding(context),
                                minute: 3,
                                onCancel: (message) => setState(() => _otpValidator = message),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                          borderRadius: 10,
                          height: mediaHeight(context, 0.055),
                          margin: EdgeInsets.only(left: mediaWidth(context, 0.033)),
                          sideColor: CustomColors.main,
                          textColor: CustomColors.main,
                          color: Colors.white,
                          width: mediaWidth(context, 0.2),
                          title: '확인',
                          onPressed: (){
                            _verification(_otp);
                          }
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: _textFieldList,
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: CustomButton(
              margin: basePadding(context),
              title: '다음으로',
              onPressed: !_allVerification ? null : () => showIndicator(_signup())
          ),
        ),
      ),
    );
  }

  List<CustomTextField> get _textFieldList => <CustomTextField>[
    CustomTextField(
      obscureText: true,
      margin: baseVerticalPadding(context),
      textFieldType: TextFieldType.underline,
      keyboardType: TextInputType.visiblePassword,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      hintText: '비밀번호(8자 이상)',
      textInputAction: TextInputAction.next,
      validator: Validations.password,
      onChanged: (password) => setState(() => _password = password),
    ),
    CustomTextField(
      obscureText: true,
      textFieldType: TextFieldType.underline,
      keyboardType: TextInputType.visiblePassword,
      hintText: '비밀번호 확인',
      autoValidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      validator: (passwordCheck) => Validations.passwordCheck(_password, passwordCheck),
      onChanged: (passwordCheck) => setState(() => _passwordCheck = passwordCheck),
    ),
    CustomTextField(
      autoValidateMode: bytesLength(_nickname) < 6 ? null : AutovalidateMode.onUserInteraction,
      margin: baseVerticalPadding(context),
      textFieldType: TextFieldType.underline,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      helperColor: CustomColors.hint,
      hintText: '닉네임',
      counterText: '${bytesLength(_nickname)}/16',
      validator: (nickname) => Validations.nickname(nickname, validator: _nicknameValidator),
      maxLength: 16,
      inputFormatters: [
        Utf8LengthLimitingTextInputFormatter(16),
      ],
      onChanged: (nickname) async{
        _nickname = nickname;
        if(bytesLength(nickname) >= 6){
          _nicknameValidator = await _nicknameCheck(nickname);
        }
        setState(() {});
      },
      onFieldSubmitted: (nickname) => showIndicator(_signup()),
    )
  ];
}
