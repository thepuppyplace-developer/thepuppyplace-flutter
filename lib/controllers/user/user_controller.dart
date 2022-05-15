import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thepuppyplace_flutter/pages/auth_page/signup_insert_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../config/local_db.dart';
import '../../models/User.dart';
import '../../repositories/user/user_repository.dart';

class UserController extends GetxController with StateMixin<User>, Config, LocalConfig{
  static UserController get to => Get.put(UserController());
  final UserRepository _repository = UserRepository();
  static final Rxn<User> _user = Rxn<User>();
  static User? get user => _user.value;

  @override
  void onReady() async{
    super.onReady();
    ever(_user, _userListener);
    _autoLogin;
    print(await jwt);
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

  //소셜 회원가입
  Future socialSignup(BuildContext context, {
    required String email,
    String? google_uid,
    String? apple_uid,
    String? nickname,
  }) async{
    int? statusCode = await _repository.socialSignup(
        context,
        email: email,
        google_uid: google_uid,
        apple_uid: apple_uid,
        nickname: nickname
    );

    switch(statusCode){
      case 201:
        Get.until((route) => route.isFirst);
        return login(context, email: email, google_uid: google_uid, apple_uid: apple_uid);
      default:
        return ;
    }
  }

  //로그인
  Future login(BuildContext context, {required String email, String? password, String? google_uid, String? apple_uid}) async{
    final String? jwt = await _repository.login(context, email, password: password, google_uid: google_uid, apple_uid: apple_uid);
    switch(jwt){
      case null:
        return network_check_message(context);
      case 'email-password-check':
        return showSnackBar(context, '이메일 혹은 비밀번호를 확인해주세요.');
      default:
        _getUser(jwt).then((User? user) async{
          if(user != null){
            Get.until((route) => route.isFirst);
            return showSnackBar(context, '${user.nickname}님 환영합니다!');
          } else {
            return null;
          }
        });
    }
  }

  Future googleLogin(BuildContext context) async{
    final GoogleSignInAccount? googleUser = await _repository.googleLogin(context);
    if(googleUser != null){
      if(await _repository.emailCheck(context, googleUser.email) == '이미 사용중인 이메일 주소입니다.'){
        return login(context, email: googleUser.email, google_uid: googleUser.id);
      } else {
        return Get.to(() => SignupInsertPage(googleUser: googleUser));
      }
    } else {
      return;
    }
  }

  Future appleLogin(BuildContext context) async{
    final AuthorizationCredentialAppleID? appleUser = await _repository.appleLogin(context);
    if(appleUser != null){
      if(await _repository.emailCheck(context, appleUser.email ?? '${appleUser.userIdentifier}@apple.com') == '이미 사용중인 이메일 주소입니다.'){
        return login(context, email: appleUser.email ?? '${appleUser.userIdentifier}@apple.com', apple_uid: appleUser.identityToken);
      } else {
        return Get.to(() => SignupInsertPage(appleUser: appleUser));
      }
    } else {
      return Get.back();
    }
  }

  Future logout(BuildContext context) async{
    _user.value = await _repository.logout(context, _user.value!.id);
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

  Future changeNotification(BuildContext context) async{
    await _repository.changeNotification(context);
    return _getUser(await jwt);
  }

  Future updateNickname(BuildContext context, String nickname) async{
    int? statusCode = await _repository.updateNickname(context, nickname);

    if(statusCode == 200){
      Get.back();
    }
    return _getUser(await jwt);
  }

  Future updatePhotoURL(BuildContext context, XFile? photo) async{
    await _repository.updatePhotoURL(context, photo);
    return _getUser(await jwt);
  }

  Future updateDefaultPhotoURL(BuildContext context) async{
    await _repository.updateDefaultPhotoURL(context);
    return _getUser(await jwt);
  }

  Future deleteUser(BuildContext context) async{
    await _repository.deleteUser(context, _user.value!.id);
    return logout(context);
  }
}