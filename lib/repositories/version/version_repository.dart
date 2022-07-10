
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../models/Version.dart';

class VersionRepository extends GetConnect with Config{

  Future<Version?> versionCheck(String version) async{
    Response res = await post('$API_URL/version/check', {
      'current_version': version
    });

    switch(res.statusCode){
      case 200:
        return Version.fromJson(res.body['data']);
      case 500:
        await showToast(res.body['message']);
        return null;
      default:
        return null;
    }
  }
}