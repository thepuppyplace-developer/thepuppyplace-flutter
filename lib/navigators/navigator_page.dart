import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/board_list_controller.dart';
import 'package:thepuppyplace_flutter/controllers/notification/notification_controller.dart';
import 'package:thepuppyplace_flutter/navigators/home_navigator.dart';
import 'package:thepuppyplace_flutter/pages/home_page/home_page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/my_page.dart';
import '../controllers/user/user_controller.dart';
import '../pages/notification_page/notification_page.dart';
import '../util/common.dart';
import '../util/custom_icons.dart';
import '../pages/insert_page/insert_board_page.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0;

  List<Widget> get _bodies => const <Widget>[
    HomeNavigator(),
    InsertBoardPage(),
    NotificationPage(),
    MyPage(),
  ];

  final List<BottomNavigationBarItem> _items = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(CustomIcons.home), label: '홈'),
    BottomNavigationBarItem(icon: Icon(CustomIcons.insert), label: '작성'),
    BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: '알림'),
    BottomNavigationBarItem(icon: Icon(CustomIcons.my_page), label: '마이페이지'),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
        init: UserController(),
        builder: (UserController controller) {
          return GetBuilder<NotificationController>(
            init: NotificationController(),
            builder: (context) {
              return Scaffold(
                body: _bodies[_currentIndex],
                bottomNavigationBar: bottomNavigationBar(),
              );
            }
          );
        }
    );
  }

  Widget bottomNavigationBar() => BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: CustomTextStyle.w500(context, height: 2, scale: 0.015),
      unselectedLabelStyle: CustomTextStyle.w500(context, scale: 0.015),
      showUnselectedLabels: false,
      unselectedItemColor: Colors.black,
      selectedItemColor: CustomColors.main,
      currentIndex: _currentIndex,
      onTap: (int index){
        switch(index){
          case 1: {
            Get.toNamed(InsertBoardPage.routeName);
            break;
          }
          default: {
            setState(() {
              _currentIndex = index;
            });
          }
        }
      },
      items: _items
  );
}
