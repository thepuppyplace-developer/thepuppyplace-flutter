import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepuppyplace_flutter/controllers/database_controller.dart';
import '../../models/User.dart';
import '../../util/common.dart';
import '../../.config.dart';

class UserRepository extends GetConnect with Config{
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
    SharedPreferences spf = await DatabaseController.spf;

    Response res = await post('$API_URL/user', {
      'email': email,
      'password': password
    });

    switch(res.statusCode){
      case 200: {
        await spf.setString('email', email);
        await spf.setString('password', password);
        return res.body['data'];
      }
      default: {
        return null;
      }
    }
  }
  
  Future<User?> getUser(String? jwt) async{
    if(jwt != null){
      Response res = await get('$API_URL/user/my', headers: headers(jwt));

      switch(res.statusCode){
        case 200: {
          return User.fromJson(res.body['data']);
        }
        default: {
          return null;
        }
      }
    } else {
      print('jwt 토큰 만료');
      return null;
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