import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
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
    await _getUser;
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

  Future signup(BuildContext context, {
    required String email,
    required String password,
    required String passwordCheck,
    required String nickname
  })
  => _repository.signUp(email: email, password: password, nickname: nickname).whenComplete(()
  => login(email: email, password: password)).whenComplete(()
  => _getUser).whenComplete(()
  => Get.until((route) => route.isFirst)).whenComplete(()
  => showSnackBar(context, '$nickname님 환영합니다!'));

  Future login({required String email, required String password}) => _repository.login(email, password)
      .whenComplete(() => _getUser
      .whenComplete(() => Get.until((route) => route.isFirst)));

  Future logout() async{
    _user.value = await _repository.logout(_user.value!.email);
    return Get.toNamed('/loginPage');
  }

  Future get _getUser async{
    if(await jwt != null){
      _user.value = await _repository.getUser(await jwt);
    } else {
      _user.value = null;
    }
  }
}