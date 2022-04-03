import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepuppyplace_flutter/controllers/database_controller.dart';

import '../../models/User.dart';
import 'user_repository.dart';

class UserController extends GetxController with StateMixin<User>{
  final UserRepository _repository = UserRepository();
  static final Rxn<User> _user = Rxn<User>();

  static final RxnString _jwt = RxnString();
  static String? get jwt => _jwt.value;

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
    SharedPreferences spf = await DatabaseController.spf;

    String? email = spf.getString('email');
    String? password = spf.getString('password');

    if(email != null && password != null){
      login(email: email, password: password);
    } else {
      _getUser();
    }
  }

  Future login({required String email, required String password}) async{
    _jwt.value = await _repository.login(email, password);
    return _getUser();
  }

  Future _getUser() async{
    _user.value = await _repository.getUser(jwt);
  }
}