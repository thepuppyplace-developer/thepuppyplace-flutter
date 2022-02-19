import 'dart:convert';

import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../.config.dart';

import '../../models/OTP.dart';

class OTPRepository extends GetConnect with Config{

  Future<OTP> sendOTPEmail(String email) async{
    Response res = await post('$APIURL/user/otp/sendOTPEmail', jsonEncode({'email': email.trim()}));

    switch(res.statusCode){
      case 201:
        await showToast('인증번호가 전송되었습니다');
        return OTP(otpId: res.body);
      case 500:
        await showToast(res.body['message']);
        return OTP();
      default:
        return OTP();
    }
  }

  Future<bool> verificationOTPEmail(OTP otp) async{
    Response res = await post('$APIURL/user/otp/${otp.otpId}', otp.toJson());

    switch(res.statusCode){
      case 200:
        await showToast('인증되었습니다');
        return true;
      case 204:
        return false;
      case 400:
        await showToast('인증번호가 일치하지 않습니다');
        return false;
      case 500:
        showToast(res.body['message']);
        return false;
      default:
        return false;
    }
  }
}