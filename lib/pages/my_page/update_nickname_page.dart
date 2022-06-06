import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/user/user_controller.dart';
import '../../repositories/user/user_repository.dart';
import '../../util/common.dart';
import '../../util/utf8_length_limiting_text_input_formatter.dart';
import '../../util/validations.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class UpdateNicknamePage extends StatefulWidget {
  const UpdateNicknamePage({Key? key}) : super(key: key);

  @override
  State<UpdateNicknamePage> createState() => _UpdateNicknamePageState();
}

class _UpdateNicknamePageState extends State<UpdateNicknamePage> {
  final _userRepo = UserRepository();
  final _nicknameKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();
  String _nickname = '';
  String? _nicknameValidator;

  Future<String?> _nicknameCheck(String nickname) async{
    final int? statusCode = await _userRepo.nicknameCheck(nickname);
    switch(statusCode){
      case 200: return null;
      case 401: return '사용할 수 없는 닉네임입니다.';
      default: return '알 수 없는 오류가 발생했습니다.';
    }
  }

  Future _updateNickname(UserController controller) async{
    try{
      if(_nicknameKey.currentState!.validate()){
        _nicknameKey.currentState!.save();
        final int? statusCode = await UserController.to.updateNickname(context, _nickname);
        switch(statusCode){
          case 200:
            await showSnackBar(context, '닉네임이 ${_nickname.trim()}으로 변경되었습니다.');
            return Get.until((route) => route.isFirst);
          case null:
            return network_check_message(context);
        }
      }
    } catch(error){
      throw Exception(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (UserController controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('내 정보 수정', style: CustomTextStyle.w600(context, scale: 0.02)),
            elevation: 0.5,
          ),
          body: controller.obx((user) => Container(
            padding: EdgeInsets.all(mediaWidth(context, 0.033)),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: mediaHeight(context, 0.1)),
                          child: Text('변경하실 새로운 닉네임을\n입력해주세요.', style: CustomTextStyle.w500(context, scale: 0.025), textAlign: TextAlign.center)),
                      Form(
                        key: _nicknameKey,
                        child: CustomTextField(
                          autofocus: true,
                          autoValidateMode: bytesLength(_nickname) < 6 ? null : AutovalidateMode.onUserInteraction,
                          margin: baseVerticalPadding(context),
                          textFieldType: TextFieldType.underline,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          hintText: '변경할 닉네임',
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
                          onFieldSubmitted: Validations.nickname(_nickname, validator: _nicknameValidator) != null ? null : (nickname) => showIndicator(_updateNickname(controller))
                        ),
                      )
                    ],
                  ),
                ),
                CustomButton(
                  title: '변경하기',
                  onPressed: Validations.nickname(_nickname, validator: _nicknameValidator) != null ? null : () => showIndicator(_updateNickname(controller)),
                )
              ],
            ),
          )),
        );
      }
    );
  }
}
