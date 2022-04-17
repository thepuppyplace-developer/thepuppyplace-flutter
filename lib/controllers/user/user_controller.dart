import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../config/local_db.dart';
import '../../models/User.dart';
import '../../repositories/user_repository.dart';

class UserController extends GetxController with StateMixin<User>, Config, LocalDB{
  static UserController get to => Get.put(UserController());
  final UserRepository _repository = UserRepository();
  static final Rxn<User> _user = Rxn<User>();
  static User? get user => _user.value;

  @override
  void onReady() async{
    super.onReady();
    ever(_user, _userListener);
    _autoLogin;
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

  //자동 로그인
  Future get _autoLogin async{
    List<User> userList = await USER_LIST();
    if(userList.isNotEmpty){
      _getUser(userList.first.jwt_token);
    } else {
      _user.value = null;
    }
  }

  //회원가입
  Future signup(BuildContext context, {
    required String email,
    required String password,
    required String passwordCheck,
    required String nickname
  })
  => _repository.signUp(context, email: email, password: password, nickname: nickname).whenComplete(()
  => login(context, email: email, password: password));

  //로그인
  Future login(BuildContext context, {required String email, required String password})
  => _repository.login(email, password).then((token){

    switch(token){
      case null:
        return network_check_message(context);
      case 'email-password-check':
        return showSnackBar(context, '이메일 혹은 비밀번호를 확인해주세요.');
      default:
        _getUser(token).then((User? user) async{
          if(user != null){
            Get.until((route) => route.isFirst);
            return showSnackBar(context, '${user.nickname}님 환영합니다!');
          } else {
            return null;
          }
        });
    }
  });

  Future logout(BuildContext context) async{
    _user.value = await _repository.logout(context);
    return Get.toNamed('/loginPage');
  }

  Future<User?> _getUser(String? token) async{
    if(token != null){
      _user.value = await _repository.getUser(token);
      return _user.value;
    } else {
      _user.value = null;
      return null;
    }
  }
}