import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/models/NotificationLog.dart';

import '../../config/config.dart';
import '../../util/common.dart';

class NotificationRepository extends GetConnect with Config{
  
  Future<Response> get getNotificationLogList async{
    try{
      final Response res = await get('$API_URL/push/my', headers: await headers);
      if(res.statusCode != null) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }
}