import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/models/NotificationLog.dart';

import '../../config/config.dart';
import '../../util/common.dart';

class NotificationRepository extends GetConnect with Config{
  
  Future<List<NotificationLog>> getNotificationLogList(BuildContext context) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await get('$API_URL/push/my', headers: await headers);

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