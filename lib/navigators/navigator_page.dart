import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/board_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/home_page/home_page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/my_page.dart';
import '../controllers/user/user_controller.dart';
import '../pages/notification_page/notification_page.dart';
import '../util/common.dart';
import '../util/custom_icons.dart';
import '../pages/insert_page/insert_page.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0;

  final List<Widget> _bodies = const <Widget>[
    HomePage(),
    InsertPage(),
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
  void initState() {
    super.initState();
    Get.put(BoardListController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (UserController controller) {
        return Scaffold(
          body: _bodies[_currentIndex],
          bottomNavigationBar: bottomNavigationBar(),
        );
      }
    );
  }

  Widget bottomNavigationBar() => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: CustomTextStyle.w500(context, height: 2),
    unselectedLabelStyle: CustomTextStyle.w500(context),
    unselectedItemColor: Colors.black,
    selectedItemColor: CustomColors.main,
      currentIndex: _currentIndex,
      onTap: (int index){
      switch(index){
        case 1: {
          Get.to(() => const InsertPage(), fullscreenDialog: true);
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