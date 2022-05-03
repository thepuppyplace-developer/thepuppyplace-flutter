import 'package:get/get.dart';
import '../../config/local_config.dart';

class DatabaseController extends GetxController with LocalConfig{
  static DatabaseController get to => DatabaseController();

  @override
  void onInit() async{
    super.onInit();
    await database;
  }
}