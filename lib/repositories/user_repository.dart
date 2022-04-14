import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';
import '../config/local_db.dart';
import '../models/User.dart';
import '../util/common.dart';

class UserRepository extends GetConnect with Config, LocalDB{

  Future<String?> signUp({required String email, required String password, required String nickname}) async{
    Response res = await post('$API_URL/user/signup', {
      'email': email,
      'password': password,
      'nickname': nickname
    });

    switch(res.statusCode){
      case 201: {
        return '$nickname님 환영합니다!';
      }
      case 401: {
        switch(res.body['message']){
          case 'already-use-email': {
            return '이미 사용중인 이메일 주소입니다.';
          }
          case 'already-use-nickname': {
            return '이미 사용중인 닉네임입니다.';
          }
          default: {
            return '사용할 수 없는 이메일 주소입니다.';
          }
        }
      }
      default: {
        return null;
      }
    }
  }

  Future<String?> login(String email, String password) async{
    SharedPreferences spf = await SharedPreferences.getInstance();
    Response res = await post('$API_URL/user', {
      'email': email,
      'password': password,
      'fcm_token': await fcm_token
    });


    switch(res.statusCode){
      case 200: {
        String? jwt = res.body['data']['jwt'];
        if(jwt != null){
          spf.setString('jwt', jwt);
        }
        return jwt;
      }
      default: {
        return null;
      }
    }
  }

  Future<User?> logout(String? email) async{
    SharedPreferences spf = await SharedPreferences.getInstance();
    await spf.remove('jwt');
    return null;
  }
  
  Future<User?> getUser(String? jwt) async{
    Response res = await get('$API_URL/user/my', headers: headers(jwt!));

    switch(res.statusCode){
      case 200: {
        User user = User.fromJson(res.body['data']);
        return user;
      }
      default: {
        return null;
      }
    }
  }

  Future<String?> sendOTP(BuildContext context, String email) async{
    final Response res = await post('$API_URL/user/auth/mail/send', {
      'email': email
    });

    switch(res.statusCode){
      case 200: {
        await showSnackBar(context, '인증번호가 전송되었습니다.');
        return res.body['data']['authNumber'];
      }
      default: {
        return null;
      }
    }
  }

  Future<String?> emailCheck(BuildContext context, String email) async{
    Response res = await post('$API_URL/user/emailcheck', {'email': email.trim()});

    switch(res.statusCode){
      case 200: {
        return null;
      }
      case 401: {
        switch(res.body['message']){
          case 'already-user-email': return '이미 사용중인 이메일주소입니다.';
          default: return null;
        }
      }
      default: {
        await network_check(context);
        return null;
      }
    }
  }

  Future<String?> nicknameCheck(String nickname) async{
    Response res = await post('$API_URL/user/nicknamecheck', {'nickname': nickname.trim()});

    switch(res.statusCode){
      case 200: {
        return null;
      }
      case 401: {
        switch(res.body['message']){
          case 'already-user-nickname': return '이미 사용중인 닉네임입니다.';
          default: return null;
        }
      }
      default: {
        return null;
      }
    }
  }
}