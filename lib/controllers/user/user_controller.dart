import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../config/local_config.dart';
import '../../models/User.dart';
import '../../repositories/user/user_repository.dart';
import '../../repositories/user/user_sql_repo.dart';

class UserController extends GetxController with StateMixin<User>, Config, LocalConfig{
  static UserController get to => Get.put(UserController());
  final UserRepository _repository = UserRepository();
  final UserSQLRepo _sql = UserSQLRepo();
  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  @override
  void onReady() {
    ever(_user, _userListener);
    _user.bindStream(_sql.GET_USER);
    super.onReady();
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
  Future login(BuildContext context, {required String email, required String password}) async{
    final String? jwt = await _repository.login(context, email, password);
    switch(jwt){
      case null:
        return network_check_message(context);
      case 'email-password-check':
        return showSnackBar(context, '이메일 혹은 비밀번호를 확인해주세요.');
      default:
        final User? user = await _refreshUser(jwt);
        if(user != null){
          Get.until((route) => route.isFirst);
          return showSnackBar(context, '${user.nickname}님 환영합니다!');
        } else {
          return null;
        }
    }
  }

  Future logout(BuildContext context) async{
    final User? resultUser = await _repository.logout(context, user!.jwt_token);
    if(resultUser == null){
      _sql.LOGOUT(_user.value!.id);
    }
    return Get.toNamed('/loginPage');
  }

  Future<User?> _refreshUser(String? token) async{
    final User? resultUser = await _repository.refreshUser(token);
    if(resultUser != null){
      _sql.REFRESH_USER(resultUser);
    }
    return resultUser;
  }

  Future changeNotification(BuildContext context) async{
    await _repository.changeNotification(context, user!.jwt_token);
    return _refreshUser(user!.jwt_token);
  }

  Future updateNickname(BuildContext context, String nickname) async{
    int? statusCode = await _repository.updateNickname(context, nickname, user!.jwt_token);

    if(statusCode == 200){
      final User? resultUser = await _repository.refreshUser(user!.jwt_token);
      _sql.REFRESH_USER(resultUser!);
      Get.back();
    }

    return _refreshUser(user!.jwt_token);
  }

  Future updatePhotoURL(BuildContext context, File? photo) async{
    await _repository.updatePhotoURL(context, photo, user!.jwt_token);
    return _refreshUser(user!.jwt_token);
  }

  Future deleteUser(BuildContext context) async{
    await _repository.deleteUser(context, user!.id, user!.jwt_token);
    return Get.toNamed('/loginPage');
  }
}