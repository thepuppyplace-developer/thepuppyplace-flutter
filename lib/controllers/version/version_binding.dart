import 'package:get/get.dart';
import 'version_controller.dart';

class VersionBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VersionController());
  }
}