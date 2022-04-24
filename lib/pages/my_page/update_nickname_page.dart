import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user/user_controller.dart';
import '../../repositories/user_repository.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class UpdateNicknamePage extends StatefulWidget {
  const UpdateNicknamePage({Key? key}) : super(key: key);

  @override
  State<UpdateNicknamePage> createState() => _UpdateNicknamePageState();
}

class _UpdateNicknamePageState extends State<UpdateNicknamePage> {
  final _repository = UserRepository();
  final _nicknameKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();
  String _nickname = '';
  String? _nicknameValidator;

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
                      Text('변경하실 새로운 닉네임을\n입력해주세요.', style: CustomTextStyle.w500(context, scale: 0.025), textAlign: TextAlign.center),
                      Form(
                        key: _nicknameKey,
                        child: CustomTextField(
                          controller: _nicknameController,
                          textFieldType: TextFieldType.underline,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: mediaHeight(context, 0.1)),
                          hintText: user!.nickname,
                          onChanged: (String nickname){
                            setState(() {
                              _nickname = nickname;
                            });
                          },
                          validator: (String? nickname){
                            if(_nickname.isEmpty){
                              return '새로운 닉네임을 입력해주세요.';
                            } else if(_nickname.length < 6){
                              return '닉네임을 6자 이상 입력해주세요.';
                            } else if(_nicknameValidator != null){
                              return _nicknameValidator;
                            } else {
                              return null;
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                CustomButton(
                  title: '변경하기',
                  onPressed: _nickname.isEmpty || _nickname.length < 6 ? null : () async{
                    _nicknameValidator = await _repository.nicknameCheck(context, _nickname);
                    if(_nicknameKey.currentState!.validate()){
                      _nicknameKey.currentState!.save();
                    }
                  },
                )
              ],
            ),
          )),
        );
      }
    );
  }
}
