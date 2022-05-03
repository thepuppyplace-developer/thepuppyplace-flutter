import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../../config/config.dart';
import '../../config/local_config.dart';
import '../../models/User.dart';
import '../../util/common.dart';

class UserRepository extends GetConnect with Config{

  Future<String?> signUp(BuildContext context, {required String email, required String password, required String nickname}) async{
    try{
      final Response res = await post('$API_URL/user/signup', {
        'email': email.trim(),
        'password': password.trim(),
        'nickname': nickname.trim()
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
          await network_check_message(context);
          return null;
        }
      }
    } catch(error) {
      throw unknown_message(context);
    }
  }

  Future<String?> login(BuildContext context, String email, String password) async{
    try{
      final Response res = await post('$API_URL/user', {
        'email': email,
        'password': password,
        'fcm_token': await fcm_token
      });

      switch(res.statusCode){
        case 200: {
          String? jwt = res.body['data']['jwt'];
          return jwt;
        }
        case 204: {
          return 'email-password-check';
        }
        default: {
          return null;
        }
      }
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<User?> logout(BuildContext context, String? jwt) async{
    try{
      if(jwt != null){
        final Response res = await patch('$API_URL/user/my', {
          'fcm_token': null,
        }, headers: headers(jwt));
        switch(res.statusCode){
          case 200:
            await showSnackBar(context, '로그아웃 되었습니다.');
            return null;
          default: return null;
        }
      } else {
        await expiration_token_message(context);
        return null;
      }
    } catch(error){
      await unknown_message(context);
      return null;
    }
  }

  Future<User?> refreshUser(String? jwt) async{
    if(jwt != null){
      final Response res = await get('$API_URL/user/my', headers: headers(jwt));

      switch(res.statusCode){
        case 200: {
          final User user = User.fromJson(res.body['data']);
          return user;
        }
        default: {
          return null;
        }
      }
    } else {
      return null;
    }
  }

  Future<User?> deleteUser(BuildContext context, int user_id, String? jwt) async{
    try{
      if(jwt != null){
        final Response res = await delete('$API_URL/user/my', headers: headers(jwt));

        switch(res.statusCode){
          case 200:
            await showSnackBar(context, '회원이 탈퇴되었습니다.');
            break;
          default:
            await network_check_message(context);
        }
      } else {
        await expiration_token_message(context);
      }
      return null;
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<String?> sendOTP(BuildContext context, String email) async{
    try{
      final Response res = await post('$API_URL/user/auth/mail/send', {
        'email': email.trim()
      });

      switch(res.statusCode){
        case 200: {
          await showSnackBar(context, '인증번호가 전송되었습니다.');
          return res.body['data']['authNumber'];
        }
        default: {
          await network_check_message(context);
          return null;
        }
      }
    } catch(error) {
      throw unknown_message(context);
    }
  }

  Future<String?> emailCheck(BuildContext context, String email) async{
    try{
      final Response res = await post('$API_URL/user/emailcheck', {'email': email.trim()});

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
          await network_check_message(context);
          return null;
        }
      }
    } catch(error) {
      throw unknown_message(context);
    }
  }

  Future<String?> nicknameCheck(BuildContext context, String nickname) async{
    try{
      final Response res = await post('$API_URL/user/nicknamecheck', {'nickname': nickname.trim()});

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
          await network_check_message(context);
          return null;
        }
      }
    } catch(error) {
      throw unknown_message(context);
    }
  }

  Future changeNotification(BuildContext context, String? jwt) async{
    try{
      if(jwt != null){
        final Response res = await patch('$API_URL/user/isalarm', {}, headers: headers(jwt));

        switch(res.statusCode){
          case 200:
            await showSnackBar(context, '알람 설정이 변경되었습니다.');
            return null;
          default:
            await network_check_message(context);
            return null;
        }
      } else {
        await expiration_token_message(context);
        return null;
      }
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<int?> updateNickname(BuildContext context, String nickname, String? jwt) async{
    try{
      if(jwt != null){
        final Response res = await patch('$API_URL/user/my', { "nickname": nickname }, headers: headers(jwt));

        print(res.body['message']);
        switch(res.statusCode){
          case 200:
            await showSnackBar(context, '닉네임이 $nickname으로 변경되었습니다.');
            return res.statusCode;
          default:
            await network_check_message(context);
            return res.statusCode;
        }
      } else {
        await expiration_token_message(context);
        return null;
      }
    } catch(error){
      await unknown_message(context);
      return null;
    }
  }

  Future updatePhotoURL(BuildContext context, File? photo, String? jwt) async{
    try{
      if(jwt != null){
        final Response res = await patch('$API_URL/user/my', FormData({
          "image": photo
        }),
            headers: headers(jwt));

        switch(res.statusCode){
          case 200:
            return null;
          default:
            return network_check_message(context);
        }
      } else {
        return expiration_token_message(context);
      }
    } catch(error){
      return unknown_message(context);
    }
  }

  Future<int?> updatePassword(BuildContext context, String? jwt, {
    required String before_password,
    required String after_password
  }) async{
    try{
      if(jwt != null){
        final Response res = await patch('$API_URL/user/password', {
          'before_password': before_password.trim(),
          'after_password': after_password.trim()
        }, headers: headers(jwt));

        switch(res.statusCode){
          case 200:
            await showSnackBar(context, '비밀번호가 변경되었습니다.');
            return res.statusCode;
          case 204:
            return res.statusCode;
          default:
            await network_check_message(context);
            return res.statusCode;
        }
      } else {
        return null;
      }
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<int?> sendPassword(BuildContext context, String email) async{
    try{
      final Response res = await post('$API_URL//user/temppw/mail/send', {
        'email': email.trim()
      });

      switch(res.statusCode){
        case 200:
          await showSnackBar(context, '임시 비밀번호가 발송되었습니다.');
          return res.statusCode;
        default:
          await network_check_message(context);
          return res.statusCode;
      }
    } catch(error){
      throw unknown_message(context);
    }
  }
}