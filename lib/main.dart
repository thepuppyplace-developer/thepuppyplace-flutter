import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_list_page.dart';
import 'package:thepuppyplace_flutter/pages/insert_page/insert_board_page.dart';
import 'package:thepuppyplace_flutter/pages/notice_page/notice_list_page.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_board_list_page.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_page.dart';
import 'controllers/database/database_controller.dart';
import 'controllers/notification/notification_controller.dart';
import 'pages/auth_page/login_page.dart';
import 'util/customs.dart';
import 'pages/splash_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print('Notification Message: ${message.data}');
}

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(NotificationController());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      routes: <String, WidgetBuilder>{
        BoardDetailsPage.routeName: (context) => const BoardDetailsPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        SearchBoardListPage.routeName: (context) => const SearchBoardListPage(),
        SearchPage.routeName: (context) => const SearchPage(),
        BoardListPage.routeName: (context) => BoardListPage(currentIndex: 0),
        InsertBoardPage.routeName: (context) => const InsertBoardPage(),
        NoticeListPage.routeName: (context) => const NoticeListPage(),
      },
      getPages: [
        GetPage(name: LoginPage.routeName, page: () => const LoginPage()),
      ],
      home: const SplashPage(),
    );
  }
}