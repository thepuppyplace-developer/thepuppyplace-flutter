import 'package:get/get.dart';

import '../../config/config.dart';
import '../../models/Term.dart';

class TermsRepo extends GetConnect with Config{
  Future<List<Term>> get getTermsList async{
    //약관 동의 항목들을 불러옴
    try{
      final Response res = await get('$API_URL/term');
      if(res.statusCode != null) print(res.body['message']);
      switch(res.statusCode){
        case 200:
          return List.from(res.body['data']).map((term) => Term.fromJson(term)).toList();
        default:
          return [];
      }
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> sendTerms(Term term) async{
    //약관 동의 체크한 항목을 서버에 전송
    try{
      final Response res = await post('$API_URL/term/user/agree', {
        "term_id": term.id,
        "is_agree": term.check
      }, headers: await headers);
      if(res.statusCode != null) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }
}