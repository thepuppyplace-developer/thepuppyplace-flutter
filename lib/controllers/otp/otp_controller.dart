import 'package:get/get.dart';

import '../../models/OTP.dart';
import 'otp_repository.dart';

class OTPController extends GetxController with StateMixin<OTP>{
  final String email;
  OTPController({required this.email});

  final OTPRepository _repository = OTPRepository();

  final Rx<OTP> _otp = Rx(OTP());

  @override
  void onReady() {
    super.onReady();
    ever(_otp, _otpListener);
    sendOTPEmail();
  }

  void _otpListener(OTP otp){
    try{
      change(null, status: RxStatus.loading());
      if(otp.otpId != null){
        change(otp, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future sendOTPEmail() async{
    _otp.value = await _repository.sendOTPEmail(email.trim());
  }

  Future<bool> verificationOTPEmail(String otpCode) async{
    _otp.value.otpCode = otpCode;
    return _repository.verificationOTPEmail(_otp.value);
  }
}