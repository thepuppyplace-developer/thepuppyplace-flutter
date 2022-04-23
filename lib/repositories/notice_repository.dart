import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../config/config.dart';
import '../models/Notice.dart';

class NoticeRepository extends GetConnect with Config{

  Future<List<Notice>> getNoticeList(BuildContext context) async{
    final res = await get('$API_URL/notice');
    
    switch(res.statusCode){
      case 200:
        return List.from(res.body['data']).map((notice) => Notice.fromJson(notice)).toList();
      default:
        await network_check_message(context);
        return [];
    }
  }
}