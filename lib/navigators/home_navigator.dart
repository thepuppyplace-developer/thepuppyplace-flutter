import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_list_page.dart';
import 'package:thepuppyplace_flutter/pages/home_page/home_page.dart';

class HomeNavigator extends StatelessWidget {

  const HomeNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (route){
        Widget page = const HomePage();
        switch(route.name){
          case HomePage.routeName: page = const HomePage(); break;
          case BoardListPage.routeName: page = BoardListPage(); break;
        }
        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }
}
