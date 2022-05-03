import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../config/config.dart';
import '../../config/local_config.dart';
import '../../models/Notice.dart';

class NoticeRepository extends GetConnect with Config, LocalConfig{

  Future<List<Notice>> getNoticeList(BuildContext context) async{
    try{
      final res = await get('$API_URL/notice');

      switch(res.statusCode){
        case 200:
          return List.from(res.body['data']).map((notice) => Notice.fromJson(notice)).toList();
        default:
          await network_check_message(context);
          return [];
      }
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<int?> insertNotice(BuildContext context, String? jwt, {required XFile? image, required String notice_title, required String notice_main_text}) async{
    try{
      if(jwt != null){
        final Response res;
        if(image != null){
          res = await post('$API_URL/notice', FormData({
            'image': image.path,
            'notice_title': notice_title.trim(),
            'notice_main_text': notice_main_text.trim()
          }));
          print(image.path);
        } else {
          res = await post('$API_URL/notice', FormData({
            'notice_title': notice_title.trim(),
            'notice_main_text': notice_main_text.trim()
          }));
        }
        switch(res.statusCode){
          case 201:
            await showSnackBar(context, '공지사항이 게시되었습니다!');
            return res.statusCode;
          default:
            await network_check_message(context);
            return null;
        }
      } else {
        await expiration_token_message(context);
        return null;
      }
    } catch(error){
      print(error);
      throw unknown_message(context);
    }
  }

  Future<int?> deleteNotice(BuildContext context, String? jwt, int? notice_id) async{
    try{
      if(jwt != null){
        final Response res = await delete('$API_URL/notice/$notice_id');

        switch(res.statusCode){
          case 200:
            await showSnackBar(context, '게시글이 삭제되었습니다.');
            return res.statusCode;
          default:
            await network_check_message(context);
            return null;
        }
      } else {
        await expiration_token_message(context);
        return null;
      }
    } catch(error){
      throw unknown_message(context);
    }
  }
}