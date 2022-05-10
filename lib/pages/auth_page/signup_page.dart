import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/widgets/checkboxes.dart';

import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_check_button.dart';
import 'signup_insert_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  bool _allCheck = false;
  List<bool> _termsCheckList = <bool>[false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: TermsCheckbox(
                allCheck: _allCheck,
                termsCheckList: _termsCheckList,
                onAllCheck: (check){
                  setState(() {
                    _allCheck = !check;
                    for(int i = 0; i < _termsCheckList.length; i++){
                      _termsCheckList[i] = !check;
                    }
                  });
                },
                onTermsCheck: (index, check){
                  setState(() {
                    _termsCheckList[index] = !check;
                    if(_termsCheckList.contains(false)){
                      _allCheck = false;
                    } else if(_termsCheckList.any((check) => true)){
                      _allCheck = true;
                    }
                  });
                }
            )
          ),
          CustomButton(
            title: '다음',
            margin: EdgeInsets.all(mediaWidth(context, 0.033)),
            height: mediaHeight(context, 0.06),
            onPressed: !_allCheck ? null : (){
              Get.to(() => const SignupInsertPage());
            },
          )
        ],
      )
    );
  }
}
