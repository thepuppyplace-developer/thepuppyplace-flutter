import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thepuppyplace_flutter/controllers/database_controller.dart';
import '../../config/local_db.dart';
import '../../models/User.dart';
import '../../repositories/user_repository.dart';

class UserController extends GetxController with StateMixin<User>, LocalDB{
  static UserController get to => Get.put(UserController());
  final UserRepository _repository = UserRepository();
  final Rxn<User> _user = Rxn<User>();


  @override
  void onReady() async{
    super.onReady();
    ever(_user, _userListener);
    _autoLogin();
  }

  void _userListener(User? user){
    try{
      change(null, status: RxStatus.loading());
      if(user != null){
        change(user, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future _autoLogin() async{
    SharedPreferences spf = await SharedPreferences.getInstance();
    String? jwt = spf.getString('jwt');
    _getUser(jwt);
  }

  Future login({required String email, required String password}) async{
    String? jwt = await _repository.login(email, password);
    await _getUser(jwt);
    return Get.back();

  }

  Future logout() async{
    _user.value = await _repository.logout(_user.value!.email);
    return Get.back();
  }

  Future _getUser(String? jwt) async{
    if(jwt != null){
      _user.value = await _repository.getUser(jwt);
    } else {
      _user.value = null;
    }
  }
}