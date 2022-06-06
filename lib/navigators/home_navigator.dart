import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_list_page.dart';
import 'package:thepuppyplace_flutter/pages/home_page/home_page.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: HomePage.routeName,
      onGenerateRoute: (route){
        Widget page;
        if(route.name == BoardListPage.routeName){
          page = const BoardListPage();
        } else {
          page = const HomePage();
        }
        // switch(route.name){
        //   case HomePage.routeName: page = const HomePage(); break;
        //   case BoardListPage.routeName: page = const BoardListPage(); break;
        // }
        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }
}
