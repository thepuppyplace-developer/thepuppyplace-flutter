import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/models/Consult.dart';
import 'package:thepuppyplace_flutter/repositories/consult.repo.dart';

class ConsultDetailsController extends GetxController with StateMixin<Consult>{
  final RxInt consultId;
  ConsultDetailsController(this.consultId);

  final _repo = ConsultRepo();

  final Rxn<Consult> _consult = Rxn<Consult>();

  @override
  void onReady() {
    super.onReady();
    ever(_consult, _consultListener);
    getConsultDetails;
  }

  void _consultListener(Consult? consult){
    change(null, status: RxStatus.loading());
    try{
      if(consult != null){
        change(consult, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future get getConsultDetails async{
    try{
      final Response res = await _repo.getConsultDetails(consultId.value);
      switch(res.statusCode){
        case 200:
          _consult.value = Consult.fromJson(res.body['data']);
          break;
        case null:
          change(null, status: RxStatus.error('인터넷 연결을 확인해주세요.'));
          break;
        default:
          _consult.value = null;
      }
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> answerConsult(int consult_id, String answer) async{
    try{
      final Response res = await _repo.answerConsult(consult_id: consult_id, answer: answer);
      switch(res.statusCode){
        case 200:
          _consult.value?.answer = answer;
          update();
      }
      return res;
    } catch(error){
      throw Exception(error);
    }
  }
}