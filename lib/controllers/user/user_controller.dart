import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/User.dart';
import 'user_repository.dart';

class UserController extends GetxController with StateMixin<User>{
  final UserRepository _repository = UserRepository();
  late SharedPreferences _sharedPreferences;

  final Rxn<User> _user = Rxn<User>();

  @override
  void onReady() async{
    super.onReady();
    _sharedPreferences = await SharedPreferences.getInstance();
    ever(_user, _userListener);
    autoLogin();
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

  Future autoLogin() async{
    if(_sharedPreferences.getString('email') != null && _sharedPreferences.getString('password') != null){
      _user.value = await _repository.findUser(1);
    } else {
      _user.value = await _repository.findUser(1);
    }
  }
}