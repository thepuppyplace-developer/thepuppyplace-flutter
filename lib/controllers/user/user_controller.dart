import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../models/User.dart';
import '../database_controller.dart';
import 'user_repository.dart';

class UserController extends GetxController with StateMixin<User>{
  final UserRepository _repository = UserRepository();
  final Rxn<User> _user = Rxn<User>();

  static final RxnString _jwt = RxnString();

  @override
  void onReady() async{
    super.onReady();
    ever(_user, _userListener);
    ever(_jwt, _jwtListener);
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

  void _jwtListener(String? jwt) async{
    SharedPreferences spf = await SharedPreferences.getInstance();

    if(jwt != null){
      await _getUser(jwt);
      await spf.setString('jwt', jwt);
    }
  }

  Future _autoLogin() async{
    SharedPreferences spf = await SharedPreferences.getInstance();

    String? email = spf.getString('email');
    String? password = spf.getString('password');

    if(email != null && password != null){
      login(email: email, password: password);
    }
  }

  Future login({required String email, required String password}) async{
    _jwt.value = await _repository.login(email, password);
  }

  Future logout(BuildContext context) async{
    SharedPreferences spf = await SharedPreferences.getInstance();
    await spf.remove('jwt');
    await spf.remove('email');
    await spf.remove('password');
    _user.value = null;
    return showSnackBar(context, '성공적으로 로그인되었습니다.');
  }

  Future _getUser(String? jwt) async{
    _user.value = await _repository.getUser(jwt);
  }
}