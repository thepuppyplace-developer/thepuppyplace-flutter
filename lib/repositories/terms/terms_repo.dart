import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/config/config.dart';
import 'package:thepuppyplace_flutter/models/Term.dart';

class TermsRepo extends GetConnect with Config{
  BuildContext context;
  TermsRepo(this.context);

  Future<List<Term>> get getTermsList async{
    try{
      final Response res = await get('$API_URL/term');
      switch(res.statusCode){
        case 200:
          return List.from(res.body['data']).map((term) => Term.fromJson(term)).toList();
        default:
          await network_check_message(context);
          return [];
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }

  Future<Term?> insertTerms({required String term_title, required String term_contents, required bool is_require}) async{
    try{
      final Response res = await post('$API_URL/term', {
        'term_title': term_title,
        'term_contents': term_contents,
        'is_require': is_require,
      });
      switch(res.statusCode){
        case 201:
          return Term.fromJson(res.body['data']);
        default:
          await network_check_message(context);
          return null;
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }
}