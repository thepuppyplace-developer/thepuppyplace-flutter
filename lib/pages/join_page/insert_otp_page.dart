import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/customs.dart';

import '../../controllers/otp/otp_controller.dart';
import '../../models/OTP.dart';

class InsertOTPPage extends StatelessWidget {
  final String email;
  final PageController pageController;

  const InsertOTPPage({
    required this.email,
    required this.pageController,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OTPController>(
        init: OTPController(email: email),
        builder: (OTPController controller) {
          return controller.obx((OTP? otp) => SafeArea(
            minimum: EdgeInsets.all(mediaWidth(context, 0.044)),
            child: Center(
              child: PinCodeTextField(
                autoFocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                showCursor: false,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    activeColor: CustomColors.main,
                    selectedColor: CustomColors.main,
                    disabledColor: CustomColors.hint,
                    inactiveColor: CustomColors.hint
                ),
                keyboardType: TextInputType.number,
                appContext: context,
                length: 6,
                onChanged: (String otp){},
                onCompleted: (String otpCode) async{
                  if(await controller.verificationOTPEmail(otpCode)){
                    pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  }
                },
                boxShadows: const [
                  BoxShadow(
                    color: CustomColors.main,
                    blurRadius: 10,
                    blurStyle: BlurStyle.inner,
                  )
                ],
              ),
            ),
          ),
            onEmpty: const Text('ss'),
            onError: (error) => CustomErrorView(error: error),
            onLoading: const CustomIndicator()
          );
        }
    );
  }
}
