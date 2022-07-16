import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../config/config.dart';
import '../../models/Member.dart';
import '../../util/common.dart';

class UserRepository extends GetConnect with Config{

  Future<Response> signup({String? email, String? password, required String nickname, String? name, GoogleSignInAccount? googleUser, AuthorizationCredentialAppleID? appleUser}) async{
    try{
      final Response res = await post('$API_URL/user/signup', {
        "uid": USER_ID(email: email, googleUser: googleUser, appleUser: appleUser)?.trim(),
        "password": password?.trim(),
        "auth_type": USER_AUTH_TYPE(googleUser: googleUser, appleUser: appleUser)?.trim(),
        "nickname": nickname.trim(),
      });
      if(res.statusCode != null && res.statusCode != 204) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> login({
    String? email,
    String? password,
    GoogleSignInAccount? googleUser,
    AuthorizationCredentialAppleID? appleUser
  }) async {
    try {
      final Response res = await post('$API_URL/user', {
        "uid": USER_ID(
            email: email, googleUser: googleUser, appleUser: appleUser),
        "password": password,
        "auth_type": USER_AUTH_TYPE(
            googleUser: googleUser, appleUser: appleUser),
        "fcm_token": await FCM_TOKEN
      });
      return res;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<GoogleSignInAccount?> get getGoogleUser async{
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      return googleUser;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<AuthorizationCredentialAppleID?> get getAppleUser async{
    try{
      final AuthorizationCredentialAppleID? appleUser = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ]
      );
      return appleUser;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Member?> logout(BuildContext context) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await patch('$API_URL/user/my', {
          'fcm_token': null,
        }, headers: await headers);
        await showSnackBar(context, '로그아웃 되었습니다.');
        return REMOVE_JWT_TOKEN;
      } else {
        await expiration_token_message(context);
        return null;
      }
    } catch(error){
      await unknown_message(context);
      return null;
    }
  }

  Future<Response> getUser() async{
    try{
      final Response res = await get('$API_URL/user/my', headers: await headers);
      if(res.statusCode != null && res.statusCode != 204) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> deleteUser(BuildContext context, int user_id) async{
    try{
      final Response res = await delete('$API_URL/user/my', headers: await headers);
      if(res.statusCode != null) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<String?> sendOTP(String email) async{
    try{
      final Response res = await post('$API_URL/user/auth/mail/send', {
        'email': email.trim()
      });
      if(res.statusCode != null) print(res.body['message']);

      switch(res.statusCode){
        case 200:
          return res.body['data']['authNumber'];
        default:
          return null;
      }
    } catch(error){
      throw Exception(error);
    }
  }

  Future<int?> emailCheck(String email) async{
    try{
      final Response res = await post('$API_URL/user/emailcheck', {
        'email': email.trim()
      });
      if(res.statusCode != null) print(res.body['message']);

      return res.statusCode;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<int?> nicknameCheck(String nickname) async{
    try{
      final Response res = await post('$API_URL/user/nicknamecheck', {
        'nickname': nickname.trim()
      });
      if(res.statusCode != null) print(res.body['message']);
      return res.statusCode;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response?> changeNotification(BuildContext context, {bool? is_alarm, bool? is_service_alarm}) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await patch('$API_URL/user/isalarm', {
          if(is_alarm != null) "is_alarm": is_alarm,
          if(is_service_alarm != null) "is_service_alarm": is_service_alarm
        }, headers: await headers);

        switch(res.statusCode){
          case 200:
            if(is_alarm != null){
              await showSnackBar(context, '알람 설정이 변경되었습니다.');
            } else {
              await showSnackBar(context, '서비스 알람 설정이 변경되었습니다.');
            }
            break;
          default:
            await network_check_message(context);
        }
        return res;
      } else {
        await expiration_token_message(context);
      }
      return null;
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<int?> updateNickname(BuildContext context, String nickname) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await patch('$API_URL/user/my', { "nickname": nickname }, headers: await headers);

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

  Future updatePhotoURL(BuildContext context, XFile? photo) async{
    try{
      if(await JWT_TOKEN != null){
        if(photo != null){
          final Response res = await patch('$API_URL/user/profile/image', FormData({
            "image": MultipartFile(await photo.readAsBytes(), filename: photo.path)
          }),
              headers: await headers);
          print(res.statusCode);

          switch(res.statusCode){
            case 200:
              return null;
            default:
              return network_check_message(context);
          }
        }
      } else {
        return expiration_token_message(context);
      }
    } catch(error){
      return unknown_message(context);
    }
  }

  Future updateDefaultPhotoURL(BuildContext context) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await patch('$API_URL/user/my/profile/image/default', {}, headers: await headers);
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

  Future<int?> updatePassword(BuildContext context, {
    required String before_password,
    required String after_password
  }) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await patch('$API_URL/user/password', {
          'before_password': before_password.trim(),
          'after_password': after_password.trim()
        }, headers: await headers);

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
      final Response res = await post('$API_URL/user/temppw/mail/send', {
        'email': email.trim()
      });


      print(res.statusCode);
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