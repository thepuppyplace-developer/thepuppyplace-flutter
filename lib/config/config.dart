import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class Config{
  final String API_URL = 'http://localhost:3000';

  Map<String, String> headers(String? jwt) => {
    'thepuppyplace': jwt!
  };

  Future<String?> get fcm_token async{
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    return fcm.getToken();
  }

  Future network_check(BuildContext context) => showSnackBar(context, '인터넷 연결을 확인해주세요.');

  Future expiration_token(BuildContext context) => showSnackBar(context, '토큰값이 만료되었습니다.');

  Future<String?> get jwt async{
    final SharedPreferences spf = await SharedPreferences.getInstance();
    return spf.getString('jwt');
  }
}