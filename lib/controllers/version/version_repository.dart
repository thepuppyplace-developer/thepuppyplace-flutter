
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../models/Version.dart';
import '../../.config.dart';

class VersionRepository extends GetConnect with Config{

  Future<Version?> versionCheck(String version) async{
    Response res = await get('$API_URL/version/$version');

    switch(res.statusCode){
      case 200:
        return Version.fromJson(res.body['data']);
      case 500:
        await showToast(res.body);
        return null;
      default:
        return null;
    }
  }
}