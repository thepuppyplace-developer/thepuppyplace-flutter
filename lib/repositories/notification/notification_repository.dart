import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/config/local_db.dart';
import 'package:thepuppyplace_flutter/models/NotificationLog.dart';

import '../../config/config.dart';

class NotificationRepository extends GetConnect with Config, LocalConfig{
  
  Future<List<NotificationLog>> getNotificationLogList(BuildContext context) async{
    try{
      if(await jwt != null){
        final Response res = await get('$API_URL/push/my', headers: headers(await jwt));

        switch(res.statusCode){
          case 200:
            return List.from(res.body['data']).map((notification) => NotificationLog.fromJson(notification)).toList();
          default:
            await network_check_message(context);
            return [];
        }
      } else {
        await expiration_token_message(context);
        return [];
      }
    } catch(error){
      throw unknown_message(context);
    }
  }
}