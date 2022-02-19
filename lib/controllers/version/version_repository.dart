import 'dart:convert';

import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../models/Version.dart';
import '../../.config.dart';

class VersionRepository extends GetConnect with Config{

  Future<Version> versionCheck(Version version) async{
    Response res = await post('$APIURL/version', jsonEncode(version.toJson()));

    switch(res.statusCode){
      case 200:
        return Version.fromJson(res.body);
      case 404:
        await showToast(res.body);
        return Version(force: true);
      case 500:
        await showToast(res.body);
        return Version(force: true);
      default:
        return Version(force: true);
    }
  }
}