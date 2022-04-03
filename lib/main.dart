import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/database_controller.dart';
import 'pages/board_page/board_details_page.dart';
import 'pages/login_page/login_page.dart';
import 'pages/navigator_page.dart';
import 'util/customs.dart';
import 'pages/splash_page.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(DatabaseController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomThemeData.light,
      getPages: [
        GetPage(name: '/navigatorPage', page: () => const NavigatorPage()),
        GetPage(name: '/loginPage', page: () => const LoginPage(), fullscreenDialog: true),
      ],
      home: const SplashPage(),
    );
  }
}