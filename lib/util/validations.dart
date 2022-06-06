import 'package:email_validator/email_validator.dart';

import 'common.dart';

class Validations{

  static String? email(String? email, {String? validator}){
    if(email!.isEmpty){
      return '이메일을 입력해주세요.';
    } else if(!EmailValidator.validate(email)){
      return '이메일 형식에 맞지 않습니다.';
    } else if(validator != null){
      return validator;
    } else {
      return null;
    }
  }

  static String? password(String? password, {String? validator}){
    if(password!.isEmpty){
      return '비밀번호를 입력해주세요.';
    } else if(password.length < 8){
      return '비밀번호를 8자 이상 입력해주세요.';
    } else if(validator != null){
      return validator;
    } else {
      return null;
    }
  }

  static String? passwordCheck(String? password, String? passwordCheck){
    if(password!.isEmpty){
      return '비밀번호를 입력해주세요.';
    } else if(password.length < 8){
      return '비밀번호를 8자 이상 입력해주세요.';
    } else if(password != passwordCheck){
      return '비밀번호가 일치하지 않습니다.';
    } else {
      return null;
    }
  }

  static String? nickname(String? nickname, {String? validator}){
    if(nickname!.isEmpty){
      return '닉네임을 입력해주세요.';
    } else if(bytesLength(nickname) < 6){
      return '닉네임을 6자 이상 입력해주세요.';
    } else if(validator != null){
      return validator;
    } else {
      return null;
    }
  }

  static String? otp(String? otp, String? validator){
    if(otp!.isEmpty){
      return '인증번호를 입력해주세요.';
    } else if(otp.length < 6){
      return '인증번호 6자를 입력해주세요.';
    } else if(validator != null){
      return validator;
    } else {
      return null;
    }
  }
}