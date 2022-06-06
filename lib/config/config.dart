import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/User.dart';

class Config{
  final String API_URL = 'http://3.36.65.93:3000';

  Future<String?> get fcm_token async{
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    return fcm.getToken();
  }

  final String channelId = 'thepuppyplace_notification_id';
  final String channelName = 'thepuppyplace';
  final String channelDescription = 'thepuppyplace_notification_channel';

  static String ADMIN_UID = '112843576180177686385';

  String? USER_ID({String? email, GoogleSignInAccount? googleUser, AuthorizationCredentialAppleID? appleUser}){
    //구글, 애플, 로컬 로그인 시 user_id 식별 함수
    if(googleUser != null){
      return googleUser.id;
    } else if(appleUser != null){
      return appleUser.userIdentifier;
    } else {
      return email;
    }
  }

  String? USER_NAME({String? name, GoogleSignInAccount? googleUser, AuthorizationCredentialAppleID? appleUser}){
    //구글, 애플 로그인 시 user_name 정하는 함수
    if(googleUser != null){
      return googleUser.displayName;
    } else if(appleUser != null){
      String? familyName = appleUser.familyName;
      String? givenName = appleUser.givenName;
      if(familyName != null && givenName != null){
        return familyName+givenName;
      } else if(familyName != null){
        return familyName;
      } else if(givenName != null){
        return givenName;
      } else {
        return null;
      }
    } else {
      return name;
    }
  }

  String? USER_AUTH_TYPE({GoogleSignInAccount? googleUser, AuthorizationCredentialAppleID? appleUser}){
    //유저 로그인 타입 함수
    if(googleUser != null){
      return 'google';
    } else if(appleUser != null){
      return 'apple';
    } else {
      return 'local';
    }
  }

  Future<String?> get FCM_TOKEN async{
    //디바이스별 FCM_TOKEN 값을 가져옴
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    return _fcm.getToken();
  }

  Future INSERT_JWT_TOKEN(String? jwt) async{
    //로그인, 회원가입 시 서버에서 받아온 jwt 값을 SharedPreferences 패키지에 JWT_TOKEN 키값에 저장
    final SharedPreferences spf = await SharedPreferences.getInstance();
    if(jwt != null){
      return spf.setString('JWT_TOKEN', jwt);
    }
  }

  Future<User?> get REMOVE_JWT_TOKEN async{
    //로그아웃, 회원 탈퇴 시 SharedPreferences 패키지에서 JWT_TOKEN 키값을 삭제하여 자동로그인을 삭제
    final SharedPreferences spf = await SharedPreferences.getInstance();
    if(await JWT_TOKEN != null){
      spf.remove('JWT_TOKEN');
    }
    return null;
  }

  Future<String?> get JWT_TOKEN async{
    //SharedPreferences 패키지 안에 JWT_TOKEN 키값을 가져옴
    final SharedPreferences spf = await SharedPreferences.getInstance();
    return spf.getString('JWT_TOKEN');
  }

  Future<Map<String, String>?> get headers async{
    final String? jwt = await JWT_TOKEN;
    if(jwt != null){
      return {'thepuppyplace': jwt};
    } else {
      return null;
    }
  }
}