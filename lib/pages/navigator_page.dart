import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/pages/home_page/home_page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/my_page.dart';

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

  List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: '홈'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: '마이페이지'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodies[_currentIndex],
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() => BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: CustomColors.background,
      currentIndex: _currentIndex,
      onTap: (int index){
        setState(() {
          _currentIndex = index;
        });
      },
      items: items
  );
}
