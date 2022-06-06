import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/config/config.dart';

import '../../models/Search.dart';
import '../../util/common.dart';

class SearchRepository extends GetConnect with Config{
  
  Future<List<Search>> getRecommendSearchList(BuildContext context, String query) async{
    try{
      final Response res = await post('$API_URL/search', {
        'query': query
      });

      switch(res.statusCode){
        case 200:
          return List.from(res.body['data']).map((search) => Search.fromJson(search)).toList();
        default:
          await network_check_message(context);
          return <Search>[];
      }
    } catch(error){
      throw unknown_message(context);
    }
  }
}