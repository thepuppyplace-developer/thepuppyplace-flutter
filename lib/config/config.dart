import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../models/User.dart';
import 'local_db.dart';

class Config{
  final String API_URL = 'http://3.36.65.93:3000';

  Map<String, String> headers(String? jwt) => {
    'thepuppyplace': jwt!
  };

  Future<String?> get fcm_token async{
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    return fcm.getToken();
  }

  Future network_check_message(BuildContext context) => showSnackBar(context, '인터넷 연결을 확인해주세요.');

  Future expiration_token_message(BuildContext context) => showSnackBar(context, '토큰값이 만료되었습니다.');

  Future unknown_message(BuildContext context) => showSnackBar(context, '알 수 없는 오류가 발생했습니다.');

  final String channelId = 'thepuppyplace_notification_id';
  final String channelName = 'thepuppyplace';
  final String channelDescription = 'thepuppyplace_notification_channel';

  static String ADMIN_EMAIL = 'hpodong@naver.com';
}