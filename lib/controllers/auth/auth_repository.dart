import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../models/User.dart';
import '../../.config.dart';

class AuthRepository extends GetConnect with Config{
  Future<User> getUser(String jsonToken) async{
    Response res = await get('$APIURL/user/:_id', headers: jsonHeader(jsonToken));

    switch(res.statusCode){
      case 200:
        await showToast('${res.body['nickname']}님 환영합니다.');
        return User.fromJson(res.body);
      case 400:
        await showToast(res.body['message']);
        return User();
      case 500:
        await showToast(res.body['message']);
        return User();
      default:
        return User();
    }
  }

  Future<String> login(String email, String password) async{
    Response res = await post('$APIURL/user/login', jsonEncode({ 'email': email.trim(), 'password': password.trim() }));
    switch(res.statusCode){
      case 200:
        return res.body;
      case 400:
        await showToast('존재하지 않는 이메일 주소입니다.');
        return '';
      case 403:
        await showToast('비밀번호가 일치하지 않습니다.');
        return '';
      case 500:
        await showToast(res.body['message']);
        return '';
      default:
        return '';
    }
  }

  Future<User> logout(User user) async{
    Response res = await put('$APIURL/user/logout/${user.userId!}', jsonEncode(user.logoutToJson()));

    switch(res.statusCode){
      case 200:
        await showToast('성공적으로 로그아웃되었습니다.');
        return User();
      case 500:
        await showToast(res.body['message']);
        return User();
      default:
        return User();
    }
  }

  Future<User> signUp(User user) async{
    Response res = await post('$APIURL/user/signUp', jsonEncode(user.joinToJson()));

    switch(res.statusCode){
      case 201:
        await showToast('${res.body['nickname']}님 환영합니다.');
        return User.fromJson(res.body);
      case 500:
        await showToast(res.body['message']);
        return User();
      default:
        return User();
    }
  }

  Future<bool> emailCheck(String email, String password, String passwordCheck) async{
    if(email.trim().isEmpty){
      await showToast('이메일 주소를 입력해주세요.');
      return false;
    } else if(!EmailValidator.validate(email.trim())){
      await showToast('이메일 주소 형식에 맞게 입력해주세요.');
      return false;
    } else if(password.trim().isEmpty){
      await showToast('비밀번호를 입력해주세요.');
      return false;
    } else if(password.trim().length < 8){
      await showToast('비밀번호를 8자 이상 입력해주세요.');
      return false;
    } else if(password.trim() != passwordCheck.trim()){
      await showToast('비밀번호가 일치하지 않습니다.');
      return false;
    } else {
      Response res = await post('$APIURL/user/emailCheck', jsonEncode({
        'email': email.trim(),
      }));

      switch(res.statusCode){
        case 200:
          return true;
        case 204:
          await showToast('이미 존재하는 이메일 주소입니다.');
          return false;
        case 500:
          await showToast(res.body['message']);
          return false;
        default:
          return false;
      }
    }
  }

  Future<bool> nicknameCheck(String nickname) async{
    if(nickname.trim().isEmpty){
      await showToast('닉네임을 입력해주세요.');
      return false;
    } else if(nickname.trim().length < 6){
      await showToast('닉네임을 6자 이상 입력해주세요.');
      return false;
    } else {
      Response res = await post('$APIURL/user/nicknameCheck', jsonEncode({
        'nickname': nickname.trim(),
      }));

      switch(res.statusCode){
        case 200:
          return true;
        case 204:
          await showToast('이미 사용중인 닉네임입니다.');
          return false;
        case 500:
          await showToast(res.body['message']);
          return false;
        default:
          return false;
      }
    }
  }
}