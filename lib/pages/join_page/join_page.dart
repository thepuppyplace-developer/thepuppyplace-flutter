import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/controllers/auth/auth_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons.dart';

import '../../controllers/auth/auth_controller.dart';
import 'insert_email_page.dart';
import 'insert_nickname_page.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final AuthRepository _repository = AuthRepository();
  final AuthController _authController = AuthController();

  final PageController _pageController = PageController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordCheck = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){unFocus(context);},
      child: Scaffold(
        appBar: appBar(),
        body: body(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: floatingActionButton()
      ),
    );
  }

  AppBar appBar() => AppBar(
    title: const Text('회원가입'),
  );

  Widget body() => PageView(
    physics: const NeverScrollableScrollPhysics(),
    onPageChanged: (int index){
      setState(() {
        _currentIndex = index;
      });
    },
    controller: _pageController,
    children: [
      InsertEmailPage(email: _email, password: _password, passwordCheck: _passwordCheck),
      InsertNicknamePage(nickname: _nickname,)
    ],
  );

  Widget floatingActionButton(){
    switch(_currentIndex){
      case 0:
        return CustomButton(
            title: '다음',
            margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.044)),
            onPressed: (){
              _pageControllerHandler();
            }
        );
      case 1:
        return CustomButton(
          title: '완료',
          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.044)),
          onPressed: (){
            _pageControllerHandler();
          },
        );
      default:
        return Container();
    }
  }

  Future _pageControllerHandler() async{
    Duration duration = const Duration(milliseconds: 500);
    Curve curve = Curves.easeIn;
    switch(_currentIndex){
      case 0:
        if(await _repository.emailCheck(_email.text, _password.text, _passwordCheck.text)){
          return _pageController.nextPage(duration: duration, curve: curve);
        }
        break;
      case 1:
        if(await _repository.nicknameCheck(_nickname.text)){
          return _authController.signUp(_email.text, _password.text, _nickname.text);
        }
    }
  }
}
