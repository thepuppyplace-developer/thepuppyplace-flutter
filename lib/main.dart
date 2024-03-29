import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:thepuppyplace_flutter/config/kakao_talk_config.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_list_page.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_report.page.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_report_details.page.dart';
import 'package:thepuppyplace_flutter/pages/insert_page/insert_board_page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/report_list.page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/update_consult.page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/user_deleted_page.dart';
import 'package:thepuppyplace_flutter/pages/notice_page/notice_list_page.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_board_list_page.dart';
import 'package:thepuppyplace_flutter/pages/search_page/search_page.dart';
import 'pages/auth_page/login_page.dart';
import 'pages/auth_page/send_password_page.dart';
import 'pages/my_page/app_info_page.dart';
import 'pages/my_page/consult.page.dart';
import 'pages/my_page/consult_details.page.dart';
import 'pages/my_page/insert_consult.page.dart';
import 'pages/my_page/update_my_page.dart';
import 'pages/my_page/update_password_page.dart';
import 'pages/notice_page/notice_insert_page.dart';
import 'util/customs.dart';
import 'pages/splash_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async{
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  KakaoSdk.init(nativeAppKey: KakaoTalkConfig.NATIVE_KEY, javaScriptAppKey: KakaoTalkConfig.JAVA_SCRIPT_KEY);
  await FirebaseDynamicLinks.instance.getInitialLink();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ko',  "KR"),
      ],
      locale: const Locale('ko',  "KR"),
      builder: (context, child) => MediaQuery(
        child: child!,
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      ),
      debugShowCheckedModeBanner: false,
      theme: CustomThemeData.light,
      routes: <String, WidgetBuilder>{
        BoardDetailsPage.routeName: (context) => const BoardDetailsPage(),
        SearchBoardListPage.routeName: (context) => const SearchBoardListPage(),
        SearchPage.routeName: (context) => const SearchPage(),
        BoardListPage.routeName: (context) => const BoardListPage(),
        NoticeListPage.routeName: (context) => const NoticeListPage(),
        SendPasswordPage.routeName: (context) => const SendPasswordPage(),
        NoticeInsertPage.routeName: (context) => const NoticeInsertPage(),
        AppInfoPage.routeName: (context) => const AppInfoPage(),
        UserDeletedPage.routeName: (context) => const UserDeletedPage(),
        UpdatePasswordPage.routeName: (context) => const UpdatePasswordPage(),
        UpdateMyPage.routeName: (context) => const UpdateMyPage(),
        ConsultPage.routeName: (context) => const ConsultPage(),
        InsertConsultPage.routeName: (context) => const InsertConsultPage(),
        ConsultDetailsPage.routeName: (context) => ConsultDetailsPage(),
        UpdateConsultPage.routeName: (context) => const UpdateConsultPage(),
        BoardReportPage.routeName: (context) => const BoardReportPage(),
        ReportListPage.routeName: (context) => const ReportListPage(),
        BoardReportDetailsPage.routeName: (context) => const BoardReportDetailsPage(),
      },
      getPages: [
        GetPage(name: LoginPage.routeName, page: () => const LoginPage(), fullscreenDialog: true),
        GetPage(name: InsertBoardPage.routeName, page: () => const InsertBoardPage(), fullscreenDialog: true),
      ],
      home: const SplashPage(),
    );
  }
}