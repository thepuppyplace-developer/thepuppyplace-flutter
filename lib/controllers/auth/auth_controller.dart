import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepuppyplace_flutter/controllers/notification/notification_controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

import '../../models/User.dart';
import 'auth_repository.dart';

class AuthController extends GetxController with StateMixin<User>{
  final AuthRepository _repo = AuthRepository();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  late SharedPreferences _sharedPreferences;

  final Rx<User?> _user = Rx(null);
  final Rx<String?> _jsonToken = Rx(null);

  @override
  void onReady() async{
    super.onReady();
    _sharedPreferences = await SharedPreferences.getInstance();
    ever(_user, _userListener);
    ever(_jsonToken, _jsonTokenListener);
    _autoLogin();
  }

  Future<String?> _deviceId() async{
    if(Platform.isAndroid){
      AndroidDeviceInfo android = await _deviceInfo.androidInfo;
      return android.androidId;
    } else {
      IosDeviceInfo ios = await _deviceInfo.iosInfo;
      return ios.identifierForVendor;
    }
  }

  void _userListener(User? user){
    try{
      change(null, status: RxStatus.loading());
      if(user!.uid != null){
        change(user, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future _jsonTokenListener(String? jsonToken) async{
    if(jsonToken != null){
      _user.value = await _repo.getUser(jsonToken);
      _sharedPreferences.setString('jsonToken', jsonToken);
    } else {
      _user.value = User();
    }
  }

  void _autoLogin(){
    if(_sharedPreferences.getString('jsonToken') != null){
      _jsonToken.value = _sharedPreferences.getString('jsonToken');
    } else {
      _jsonToken.value = null;
    }
  }

  Future login(String email, String password) async{
    if(email.trim().isEmpty){
      await showToast('이메일 주소를 입력해주세요');
    } else if(!EmailValidator.validate(email.trim())){
      await showToast('이메일 주소 형식에 맞게 입력해주세요');
    } else if(password.trim().isEmpty){
      await showToast('비밀번호를 입력해주세요');
    } else {
      _jsonToken.value = await _repo.login(User(
        email: email.trim(),
        password: password.trim(),
        fcmToken: NotificationController.to.fcmToken,
        deviceId: await _deviceId()
      ));
      if(_jsonToken.value != null){
        Get.back();
        return Get.back();
      }
    }
  }

  Future signUp(String email, String password, String nickname) async{
    _jsonToken.value = await _repo.signUp(User(
        email: email.trim(),
        password: password.trim(),
        nickname: nickname.trim(),
        fcmToken: NotificationController.to.fcmToken,
        deviceId: await _deviceId()
    ));
    if(_jsonToken.value != null){
      Get.back();
      return Get.back();
    }
  }

  Future logout() async{
    _user.value = await _repo.logout(_user.value!);
    await _sharedPreferences.remove('jsonToken');
    return Get.toNamed('/loginPage');
  }
}