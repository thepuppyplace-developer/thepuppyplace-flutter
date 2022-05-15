import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/terms_list_controller.dart';
import 'package:thepuppyplace_flutter/widgets/checkboxes.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import 'signup_insert_page.dart';

class SignupTermsPage extends StatefulWidget {
  const SignupTermsPage({Key? key}) : super(key: key);

  @override
  State<SignupTermsPage> createState() => _SignupTermsPageState();
}

class _SignupTermsPageState extends State<SignupTermsPage> {

  bool _allCheck = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsListController>(
      init: TermsListController(context),
      builder: (TermsListController controller) {
        return Scaffold(
          appBar: AppBar(
            titleTextStyle: CustomTextStyle.w600(context),
            title: const Text('회원가입'),
          ),
          body: controller.obx((termsList) => Column(
            children: [
              Expanded(
                  child: TermsCheckbox(
                      allCheck: _allCheck,
                      termsCheckList: controller.checkList,
                      termsList: termsList!,
                      onAllCheck: (check){
                        setState(() {
                          _allCheck = !check;
                          for(int i = 0; i < controller.checkList.length; i++){
                            controller.checkList[i] = !check;
                          }
                        });
                      },
                      onTermsCheck: (index, check){
                        setState(() {
                          controller.checkList[index] = !check;
                          if(controller.checkList.contains(false)){
                            _allCheck = false;
                          } else if(controller.checkList.any((check) => true)){
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
          ))
        );
      }
    );
  }
}
