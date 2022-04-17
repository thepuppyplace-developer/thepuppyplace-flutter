import 'package:flutter/material.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class UpdateNicknamePage extends StatelessWidget {
  const UpdateNicknamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('내 정보 수정', style: CustomTextStyle.w600(context, scale: 0.02)),
          elevation: 0.5,
        ),
        body: Container(
          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('변경하실 새로운 닉네임을\n입력해주세요.', style: CustomTextStyle.w500(context, scale: 0.025), textAlign: TextAlign.center),
                    CustomTextField(
                      textFieldType: TextFieldType.underline,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: mediaHeight(context, 0.1)),
                      onChanged: (String nickname){},
                    )
                  ],
                ),
              ),
              CustomButton(
                title: '변경하기',
                onPressed: (){},
              )
            ],
          ),
        ),
      ),
    );
  }
}
