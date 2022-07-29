import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thepuppyplace_flutter/controllers/notification/notification_log_list_controller.dart';
import 'package:thepuppyplace_flutter/navigators/navigator_page.dart';
import 'package:thepuppyplace_flutter/pages/auth_page/signup_terms_page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/user_deleted_page.dart';
import 'package:thepuppyplace_flutter/repositories/terms/terms_repo.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../models/Term.dart';
import '../../models/Member.dart';
import '../../pages/auth_page/login_page.dart';
import '../../repositories/user/user_repository.dart';

class UserController extends GetxController with StateMixin<Member>, Config{
  static UserController get to => Get.put(UserController());
  final UserRepository _repo = UserRepository();
  final TermsRepo _termsRepo = TermsRepo();
  static final Rxn<Member> _user = Rxn<Member>();
  static Member? get user => _user.value;

  @override
  void onReady() async{
    super.onReady();
    ever(_user, _userListener);
    _user.value = await getUser;
    print(await JWT_TOKEN);
  }

  void _userListener(Member? user){
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
  Future<int?> signup(List<Term> termsList, {String? email, String? password, required String nickname, GoogleSignInAccount? googleUser, AuthorizationCredentialAppleID? appleUser}) async{
    try{
      final Response res = await _repo.signup(email: email, password: password, nickname: nickname, googleUser: googleUser, appleUser: appleUser);

      switch(res.statusCode){
        case 201:
          int? statusCode = await login(email: email, password: password, googleUser: googleUser, appleUser: appleUser);
          switch(statusCode){
            case 200:
            //회원가입이 완료되면 send 로그인 한 후 약관 체크한 항목들을 jwt 와 함께 서버에 전송
            for(Term term in termsList){
              await _termsRepo.sendTerms(term);
            }
          }
          break;
        default:
      }
      return res.statusCode;
    } catch(error){
      throw Exception(error);
    }
  }

  //로그인
  Future<int?> login({String? email, String? password, GoogleSignInAccount? googleUser, AuthorizationCredentialAppleID? appleUser}) async{
    //유저 로그인 부분
    final Response res = await _repo.login(email: email, password: password, googleUser: googleUser, appleUser: appleUser);
    switch(res.statusCode){
      case 200:
        final String? jwt = res.body['data']['jwt'];
        if(jwt != null){
          await INSERT_JWT_TOKEN(jwt);
          _user.value = await getUser;
          NotificationLogListController.to.refreshLogList;
        }
    }
    return res.statusCode;
  }

  Future<int?> get googleLogin async{
    final GoogleSignInAccount? googleUser = await _repo.getGoogleUser;
    if(googleUser != null){
      int? statusCode = await login(googleUser: googleUser);
      switch(statusCode){
        case 204:
        //statusCode 401은 회원이 존재하지 않는다는 의미로 회원가입 페이지로 넘김
          await Get.to(() => SignupTermsPage(googleUser: googleUser));
      }
      return statusCode;
    } else {
      return null;
    }
  }

  Future<int?> get appleLogin async{
    try{
      final AuthorizationCredentialAppleID? appleUser = await _repo.getAppleUser;
      if(appleUser != null){
        int? statusCode = await login(appleUser: appleUser);
        switch(statusCode){
          case 204:
          //statusCode 401은 회원이 존재하지 않는다는 의미로 회원가입 페이지로 넘김
            await Get.to(() => SignupTermsPage(appleUser: appleUser));
        }
        return statusCode;
      } else {
        return null;
      }
    } catch(error){
      throw Exception(error);
    }
  }

  Future logout(BuildContext context) async{
    _user.value = await _repo.logout(context);
    //로그아웃 시 서버에 전송
    _user.value = await REMOVE_JWT_TOKEN;
    //SharedPreferences 에 JWT_TOKEN 값을 삭제함

    return Get.offNamedUntil(LoginPage.routeName, (route) => route.isFirst);
    //JWT_TOKEN 을 삭제하면 로그인 페이지로 넘긴 후 앞에 Stack 을 모두 제거
  }

  Future<Member?> get getUser async{
    final Response res = await _repo.getUser();
    switch(res.statusCode){
      case 200:
        final Member user = Member.fromJson(res.body['data']);
        _user.value = user;
        return user;
    //statusCode 가 200일 경우에만 user 상세를 불러옴
      default: return null;
    }
  }

  Future<Response> changeNotification(BuildContext context, {bool? is_alarm, bool? is_service_alarm}) async{
    final Response? res = await _repo.changeNotification(context, is_alarm: is_alarm, is_service_alarm: is_service_alarm);
    switch(res?.statusCode){
      case 200:
        if(is_alarm != null) _user.value?.is_alarm = is_alarm;
        if(is_service_alarm != null) _user.value?.is_service_alarm = is_service_alarm;
        update();
        break;
    }
    return res!;
  }

  Future updateNickname(BuildContext context, String nickname) async{
    int? statusCode = await _repo.updateNickname(context, nickname);

    if(statusCode == 200){
      Get.back();
    }
    return getUser;
  }

  Future updatePhotoURL(BuildContext context, XFile? photo) async{
    await _repo.updatePhotoURL(context, photo);
    return getUser;
  }

  Future deletePhotoURL(BuildContext context) async{
    await _repo.deletePhotoURL(context);
    return getUser;
  }

  Future deleteUser(BuildContext context) async{
    try{
      final Response res = await _repo.deleteUser(context, _user.value!.id);
      switch(res.statusCode){
        case 200:
          await showSnackBar(context, '회원이 탈퇴되었습니다.');
          _user.value = await REMOVE_JWT_TOKEN;
          return Get.offNamedUntil(UserDeletedPage.routeName, (route) => route.isFirst);
        default:
          return network_check_message(context);
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }
}