import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/home_page/home_page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/my_page.dart';

import '../controllers/auth/auth_controller.dart';
import '../util/common.dart';
import '../util/customs.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0;

  List<Widget> bodies = <Widget>[
    HomePage(),
    MyPage(),
  ];

  List<IconData> items = <IconData>[
    Icons.home,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (AuthController controller) {
        return Scaffold(
          body: bodies[_currentIndex],
          bottomNavigationBar: bottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){},
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      }
    );
  }

  Widget bottomNavigationBar() => AnimatedBottomNavigationBar(
    activeColor: Colors.blue,
    notchSmoothness: NotchSmoothness.smoothEdge,
    gapLocation: GapLocation.center,
      leftCornerRadius: 30,
      rightCornerRadius: 30,
      activeIndex: _currentIndex,
      onTap: (int index){
        setState(() {
          _currentIndex = index;
        });
      },
      icons: items
  );
}
