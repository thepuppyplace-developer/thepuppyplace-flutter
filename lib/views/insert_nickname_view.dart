import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thepuppyplace_flutter/repositories/user/user_repository.dart';
import '../../models/Term.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';
import '../controllers/user/user_controller.dart';
import '../util/utf8_length_limiting_text_input_formatter.dart';
import '../util/validations.dart';

class InsertNicknameView extends StatefulWidget {
  final List<Term> termsList;
  final GoogleSignInAccount? googleUser;
  final AuthorizationCredentialAppleID? appleUser;

  const InsertNicknameView(
      this.termsList,{
        this.googleUser,
        this.appleUser,
        Key? key}) : super(key: key);

  @override
  State<InsertNicknameView> createState() => _InsertNicknameViewState();
}

class _InsertNicknameViewState extends State<InsertNicknameView> {

  final UserRepository _userRepo = UserRepository();
  final GlobalKey<FormState> _nicknameKey = GlobalKey<FormState>();
  String _nickname = '';
  String? _nicknameValidator;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: basePadding(context),
      child: Column(
        children: [
          Form(
            key: _nicknameKey,
            child: CustomTextField(
              autoValidateMode: bytesLength(_nickname) < 6 ? null : AutovalidateMode.onUserInteraction,
              autofocus: true,
              margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
              counterText: '${bytesLength(_nickname)}/16',
              textFieldType: TextFieldType.outline,
              hintText: '닉네임',
              helperText: '닉네임을 입력해주세요.',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              helperColor: CustomColors.hint,
              onChanged: (nickname) async{
                _nickname = nickname;
                if(bytesLength(nickname) >= 6){
                  _nicknameValidator = await _nicknameCheck(nickname);
                }
                setState(() {});
              },
              validator: (nickname) => Validations.nickname(nickname, validator: _nicknameValidator),
              onFieldSubmitted: Validations.nickname(_nickname, validator: _nicknameValidator) != null ? null : (nickname) => showIndicator(_signup),
              maxLength: 16,
              inputFormatters: [
                Utf8LengthLimitingTextInputFormatter(16),
              ],
            ),
          ),
          CustomButton(
              borderRadius: mediaHeight(context, 1),
              title: '가입',
              onPressed: Validations.nickname(_nickname, validator: _nicknameValidator) != null ? null : () => showIndicator(_signup)
          )
        ],
      ),
    );
  }

  Future<String?> _nicknameCheck(String nickname) async{
    final int? statusCode = await _userRepo.nicknameCheck(nickname);
    switch(statusCode){
      case 200: return null;
      case 401: return '사용할 수 없는 닉네임입니다.';
      default: return '알 수 없는 오류가 발생했습니다.';
    }
  }

  Future get _signup async{
    try{
      if(_nicknameKey.currentState!.validate()){
        _nicknameKey.currentState!.save();
        final int? statusCode = await UserController.to.signup(widget.termsList, nickname: _nickname, googleUser: widget.googleUser, appleUser: widget.appleUser);
        switch(statusCode){
          case 201:
            await showSnackBar(context, '환영합니다.');
            return Get.until((route) => route.isFirst);
          case 400:
            return showSnackBar(context, '가입에 실패하였습니다.');
          case null:
            return network_check_message(context);
        }
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }
}