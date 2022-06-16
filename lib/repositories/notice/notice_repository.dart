import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../models/Notice.dart';

class NoticeRepository extends GetConnect with Config{

  Future<Response> get getNoticeList async{
    try{
      final Response res = await get('$API_URL/notice');
      if(res.statusCode != null) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> insertNotice({required XFile? image, required String notice_title, required String notice_main_text}) async{
    try{
      final Response res = await post('$API_URL/notice', FormData({
        'image': image == null ? null : MultipartFile(await image.readAsBytes(), filename: image.path),
        'notice_title': notice_title.trim(),
        'notice_main_text': notice_main_text.trim()
      }));
      if(res.statusCode != null) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> updateNotice({
    required int notice_id,
    required String title,
    required String description,
  }) async{
    try{
      final Response res = await patch('$API_URL/notice/$notice_id', FormData({
        'notice_title': title.trim(),
        'notice_main_text': description.trim()
      }), headers: await headers);
      if(res.statusCode != null) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> deleteNotice(int? notice_id) async{
    try{
      final Response res = await delete('$API_URL/notice/$notice_id');
      if(res.statusCode != null) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }
}