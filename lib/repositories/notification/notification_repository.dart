import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';

class NotificationRepository extends GetConnect with Config{
  
  Future<Response> getNotificationLogList(int page) async{
    try{
      final Response res = await get('$API_URL/push/my/$page', headers: await headers);
      return returnResponse(res);
    } catch(error){
      throw Exception(error);
    }
  }
}