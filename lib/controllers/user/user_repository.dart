import 'package:get/get.dart';
import '../../models/User.dart';
import '../../util/common.dart';
import '../../.config.dart';

class UserRepository extends GetConnect with Config{
  Future<User?> findUser(int user_id) async{
    Response res = await get('$API_URL/user/$user_id');

    switch(res.statusCode){
      case 200: {
        return User.fromJson(res.body['data']);
      }
      case 204: {
        return null;
      }
      case 500: {
        return null;
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