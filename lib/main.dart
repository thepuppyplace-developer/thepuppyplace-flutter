import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:thepuppyplace_flutter/config/kakao_talk_config.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_list_page.dart';
import 'package:thepuppyplace_flutter/pages/insert_page/insert_board_page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/user_deleted_page.dart';
import 'package:thepuppyplace_flutter/pages/notice_page/notice_list_page.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_board_list_page.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_page.dart';
import 'controllers/notification/notification_controller.dart';
import 'pages/auth_page/login_page.dart';
import 'pages/auth_page/send_password_page.dart';
import 'pages/home_page/home_page.dart';
import 'pages/my_page/app_info_page.dart';
import 'pages/my_page/update_my_page.dart';
import 'pages/my_page/update_password_page.dart';
import 'pages/notice_page/notice_insert_page.dart';
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
  KakaoSdk.init(nativeAppKey: KakaoTalkConfig.nativeKey);
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
        BoardListPage.routeName: (context) => const BoardListPage(),
        InsertBoardPage.routeName: (context) => const InsertBoardPage(),
        NoticeListPage.routeName: (context) => const NoticeListPage(),
        HomePage.routeName: (context) => const HomePage(),
        SendPasswordPage.routeName: (context) => const SendPasswordPage(),
        NoticeInsertPage.routeName: (context) => const NoticeInsertPage(),
        AppInfoPage.routeName: (context) => const AppInfoPage(),
        UserDeletedPage.routeName: (context) => const UserDeletedPage(),
        UpdatePasswordPage.routeName: (context) => const UpdatePasswordPage(),
        UpdateMyPage.routeName: (context) => const UpdateMyPage(),
      },
      getPages: [
        GetPage(name: LoginPage.routeName, page: () => const LoginPage(), fullscreenDialog: true),
        GetPage(name: BoardListPage.routeName, page: () => const BoardListPage()),
      ],
      home: const SplashPage(),
    );
  }
}