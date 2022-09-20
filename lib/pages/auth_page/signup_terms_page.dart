import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thepuppyplace_flutter/controllers/terms_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/auth_page/insert_nickname_page.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/checkboxes.dart';
import '../../models/Term.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import 'signup_insert_page.dart';

class SignupTermsPage extends StatefulWidget {
  static const String routeName = '/termsCheckPage';
  final GoogleSignInAccount? googleUser;
  final AuthorizationCredentialAppleID? appleUser;

  const SignupTermsPage({
    this.googleUser,
    this.appleUser,
    Key? key}) : super(key: key);

  @override
  State<SignupTermsPage> createState() => _SignupTermsPageState();
}

class _SignupTermsPageState extends State<SignupTermsPage> {

  bool _allCheck = false;

  bool _termsCheck(List<Term> termsList){
    if(termsList.where((term) => term.is_required).every((term) => term.check == true)){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsListController>(
        init: TermsListController(context),
        builder: (TermsListController controller) {
          return Scaffold(
            appBar: AppBar(),
            body: controller.obx((termsList) => SingleChildScrollView(
              padding: basePadding(context).add(baseHorizontalPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('회원가입', style: CustomTextStyle.w500(context, scale: 0.025)),
                  Container(
                      margin: baseVerticalPadding(context),
                      child: Text('서비스 가입을 위해 약관동의가 필요해요.', style: CustomTextStyle.w500(context, color: CustomColors.hint))),
                  SizedBox(height: mediaHeight(context, 0.05)),
                  TermsCheckbox(
                      allCheck: _allCheck,
                      termsList: termsList!,
                      onAllCheck: (check){
                        setState(() {
                          _allCheck = !check;
                          for(Term term in termsList){
                            term.check = !check;
                          }
                        });
                      },
                      onTermsCheck: (index, check){
                        setState(() {
                          controller.termsList[index].check = !check;
                          if(controller.termsList.any((term) => term.check == false)){
                            _allCheck = false;
                          } else if(controller.termsList.any((term) => term.check == true)){
                            _allCheck = true;
                          }
                        });
                      }
                  ),
                  SizedBox(height: mediaHeight(context, 0.1))
                ],
              ),
            ),
                onEmpty: const EmptyView(),
                onError: (error) => ErrorView(error),
                onLoading: const LoadingView()
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: CustomButton(
                margin: baseHorizontalPadding(context),
                title: '다음',
                onPressed: !_termsCheck(controller.termsList) ? null : () {
                  if(widget.googleUser != null){
                    print(widget.googleUser!.email);
                    return Get.to(() => InsertNicknamePage(controller.termsList, googleUser: widget.googleUser));
                  } else if(widget.appleUser != null){
                    return Get.to(() => InsertNicknamePage(controller.termsList, appleUser: widget.appleUser));
                  } else {
                    return Get.to(() => SignupInsertPage(termsList: controller.termsList));
                  }
                }
            ),
          );
        }
    );
  }
}
