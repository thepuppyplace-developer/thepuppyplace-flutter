import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/config/config.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class ConsultRepo extends GetConnect with Config{

  Future<Response> getMyConsultList(int page) async{
    try{
      final Response res = await post('$API_URL/consult/my', {
        'page': page
      }, headers: await headers);
      return returnResponse(res);
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> insertConsult({
    required String title,
    required String description,
    required List<XFile?> photoList,
  }) async{
    try{
      FormData _formData = FormData({
        'title': title.trim(),
        'description': description.trim(),
      });
      for(XFile? photo in photoList){
        if(photo != null){
          _formData.files.add(MapEntry('consult_photos', MultipartFile(await photo.readAsBytes(), filename: photo.path)));
        }
      }
      final Response res = await post('$API_URL/consult', _formData, headers: await headers);
      return returnResponse(res);
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> answerConsult({
    required int consult_id,
    required String answer
  }) async{
    try{
      final Response res = await post('$API_URL/consult/answer/$consult_id', {
        'answer': answer.trim()
      });
      return returnResponse(res);
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> getAdminConsultList(int page) async{
    try{
      final Response res = await post('$API_URL/consult/all', {
        'page': page
      }, headers: await headers);
      return returnResponse(res);
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> getConsultDetails(int consult_id) async{
    try{
      final Response res = await get('$API_URL/consult/$consult_id');
      return returnResponse(res);
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> updateConsult({
    required int consult_id,
    required String title,
    required String description,
  }) async{
    try{
      final Response res = await patch('$API_URL/consult/$consult_id', {
        'title': title.trim(),
        'description': description.trim(),
      }, headers: await headers);
      return returnResponse(res);
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> deleteConsult(int consult_id) async{
    try{
      final Response res = await delete('$API_URL/consult/my/$consult_id', headers: await headers);
      return returnResponse(res);
    } catch(error){
      throw Exception(error);
    }
  }
}