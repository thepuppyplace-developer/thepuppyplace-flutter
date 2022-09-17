import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/config/config.dart';
import 'package:thepuppyplace_flutter/controllers/user/user_controller.dart';
import 'package:thepuppyplace_flutter/repositories/consult.repo.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../models/Consult.dart';

class ConsultListController extends GetxController with StateMixin<List<Consult>>{
  static ConsultListController get instance => Get.put(ConsultListController());

  final _repo = ConsultRepo();

  final RxList<Consult> _consultList = RxList<Consult>();
  final RxInt _page = RxInt(0);

  @override
  void onReady() {
    super.onReady();
    ever(_consultList, _consultListListener);
    refreshConsultList;
  }

  void _consultListListener(List<Consult> consultList){
    change(null, status: RxStatus.loading());
    try{
      if(consultList.isNotEmpty){
        change(consultList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  void addAnswer(int consultId, String answer){
    try{
      _consultList[_consultList.indexWhere((consult) => consult.consultId == consultId)].answer = answer;
      update();
    } catch(error){
      throw Exception(error);
    }
  }

  Future get refreshConsultList async{
    _page.value = 0;
    try{
      final Response res = isAdmin
          ? await _repo.getAdminConsultList(_page.value)
          : await _repo.getMyConsultList(_page.value);
      switch(res.statusCode){
        case 200:
          final List<Consult> consultList = List.from(res.body['data']).map((consult) => Consult.fromJson(consult)).toList();
          _consultList.addAll(consultList);
          break;
        case null:
          change(null, status: RxStatus.error('인터넷 연결을 확인해주세요.'));
          break;
        default:
          _consultList.clear();
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
      throw Exception(error);
    }
  }

  Future get getConsultList async{
    _page.value++;
    try{
      final Response res = await _repo.getMyConsultList(_page.value);
      switch(res.statusCode){
        case 200:
          final List<Consult> consultList = List.from(res.body['data']).map((consult) => Consult.fromJson(consult)).toList();
          _consultList.addAll(consultList);
      }
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
      final Response res = await _repo.insertConsult(title: title, description: description, photoList: photoList);
      switch(res.statusCode){
        case 201:
          _consultList.insert(0, Consult.fromJson(res.body['data']));
          update();
      }
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> deleteConsult(int consultId) async{
    try{
      final Response res = await _repo.deleteConsult(consultId);
      switch(res.statusCode){
        case 200:
          _consultList.removeAt(_consultList.indexWhere((consult) => consult.consultId == consultId));
          update();
      }
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> updateConsult({
    required int consultId,
    required String title,
    required String description,
  }) async{
    try{
      final Response res = await _repo.updateConsult(consult_id: consultId, title: title, description: description);
      switch(res.statusCode){
        case 200:
          _consultList[_consultList.indexWhere((consult) => consult.consultId == consultId)] = Consult.fromJson(res.body['data']);
          update();
      }
      return res;
    } catch(error){
      throw Exception(error);
    }
  }
}