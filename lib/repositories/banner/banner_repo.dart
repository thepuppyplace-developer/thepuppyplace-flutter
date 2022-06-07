import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/config/config.dart';

class BannerRepo extends GetConnect with Config{
  
  Future<Response> get getBannerList async{
    try{
      final Response res = await get('$API_URL/banner');
      if(res.statusCode != null) print(res.body['message']);
      return res;
    } catch(error){
      throw Exception(error);
    }
  }
}