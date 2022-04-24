import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../config/config.dart';
import '../config/local_db.dart';
import '../models/User.dart';
import '../util/common.dart';

class UserRepository extends GetConnect with Config, LocalConfig{

  Future<String?> signUp(BuildContext context, {required String email, required String password, required String nickname}) async{
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
  }

  Future<String?> login(String email, String password) async{
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
  }

  Future<User?> logout(BuildContext context) async{
    try{
      if(await jwt != null){
        final Database db = await database;
        final Response res = await patch('$API_URL/user/my', {
          'fcm_token': null,
        });
        switch(res.statusCode){
          case 200:
            final userList = await db.rawQuery('SELECT * FROM User');
            if(userList.isNotEmpty){
              await db.rawDelete('TRUNCATE User');
              await showSnackBar(context, '로그아웃 되었습니다.');
              return null;
            } else {
              await showSnackBar(context, '로그아웃 되었습니다.');
              return null;
            }
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

  Future<User?> getUser(String? token) async{
    if(token != null){
      final Response res = await get('$API_URL/user/my', headers: headers(token));

      switch(res.statusCode){
        case 200: {
          final Database db = await database;
          final User user = User.fromJson(res.body['data']);
          final userList = await USER_LIST(where: 'id = ?', whereArgs: [user.id]);
          if(userList.isNotEmpty){
            await db.update(User.TABLE, user.toJson(), where: 'id = ?', whereArgs: [user.id]);
          } else {
            await db.insert(User.TABLE, user.toJson());
          }
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

  Future<String?> sendOTP(BuildContext context, String email) async{
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
        await network_check_message(context);
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

  Future changeNotification(BuildContext context) async{
    try{
      if(await jwt != null){
        final res = await patch('$API_URL/user/isalarm', {}, headers: headers(await jwt));

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

  Future updateNickname(BuildContext context, String nickname) async{
    try{
      if(await jwt != null){
        final Response res = await patch('$API_URL/user/my', { "nickname": nickname }, headers: headers(await jwt));

        switch(res.statusCode){
          case 200:
            await showSnackBar(context, '닉네임이 $nickname으로 변경되었습니다.');
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
}