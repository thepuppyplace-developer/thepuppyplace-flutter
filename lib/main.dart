import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/notification/notification_controller.dart';
import 'controllers/version/version_controller.dart';
import 'pages/login_page/login_page.dart';
import 'pages/navigator_page.dart';
import 'util/customs.dart';
import 'pages/splash_page.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  Get.put(VersionController());
  Get.put(NotificationController());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomThemeData.light,
      getPages: [
        GetPage(name: '/splashPage', page: () => const SplashPage()),
        GetPage(name: '/navigatorPage', page: () => const NavigatorPage()),
        GetPage(name: '/loginPage', page: () => const LoginPage(), fullscreenDialog: true),
      ],
      initialRoute: '/splashPage',
    );
  }
}