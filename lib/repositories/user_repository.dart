import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thepuppyplace_flutter/controllers/database_controller.dart';
import '../config/config.dart';
import '../config/local_db.dart';
import '../models/User.dart';
import '../util/common.dart';

class UserRepository extends GetConnect with Config, LocalDB{
  Future<bool?> signUp({required String email, required String password, required String nickname}) async{
    Response res = await post('$API_URL/user/signup', {
      'email': email,
      'password': password,
      'nickname': nickname
    });

    switch(res.statusCode){
      case 200: {
        return true;
      }
      case 204: {
        return false;
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
        String jwt = res.body['data']['jwt'];
        spf.setString('jwt', jwt);
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

  Future<bool> emailCheck(String email) async{
    Response res = await post('$API_URL/user/emailcheck', {'email': email.trim()});

    switch(res.statusCode){
      case 200: {
        return res.body['data'];
      }
      case 401: {
        await showToast(res.body['message']);
        return res.body['data'];
      }
      case 500: {
        return false;
      }
      default: {
        return false;
      }
    }
  }

  Future<bool> nicknameCheck(String email) async{
    Response res = await post('$API_URL/user/nicknamecheck', {'email': email.trim()});

    switch(res.statusCode){
      case 200: {
        return res.body['data'];
      }
      case 401: {
        await showToast(res.body['message']);
        return res.body['data'];
      }
      case 500: {
        return false;
      }
      default: {
        return false;
      }
    }
  }
}