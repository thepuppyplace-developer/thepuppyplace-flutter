import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../models/Version.dart';
import '../../repositories/version/version_repository.dart';

class VersionController extends GetxController with StateMixin<Version>{
  final VersionRepository _repo = VersionRepository();
  late PackageInfo _packageInfo;

  final Rxn<Version> _version = Rxn<Version>();

  @override
  void onReady() async{
    super.onReady();
    _packageInfo = await PackageInfo.fromPlatform();
    ever(_version, _versionListener);
    _versionCheck();
  }

  void _versionListener(Version? version){
    try{
      change(null, status: RxStatus.loading());
      if(version != null){
        Future.delayed(const Duration(seconds: 2), (){
          version.isRequired ?
          change(version, status: RxStatus.error('업데이트를 해주세요.')) :
          change(version, status: RxStatus.success());
        });
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future _versionCheck() async{
    _version.value = await _repo.versionCheck(_packageInfo.version);
  }
}