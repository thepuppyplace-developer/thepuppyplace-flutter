import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class DynamicConfig {
  static DynamicConfig get instance => DynamicConfig();

  final String _android = dotenv.get('ANDROID_PACKAGE_NAME');
  final String _ios = dotenv.get('IOS_PACKAGE_NAME');
  final String _dynamicLink = dotenv.get('DYNAMIC_LINK');
  final String _appStoreId = dotenv.get('APP_STORE_ID');

  void get dynamicLinkListener => FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? data){
    final Uri? deepLink = data?.link;

    if (deepLink != null) return _dynamicLinkHandler(deepLink);
  },
    onError: (error) => throw Exception(error),
  );

  void _dynamicLinkHandler(Uri uri){
    final String? routeName = uri.queryParameters['routeName'];
    final String? id = uri.queryParameters['id'];

    if(routeName != null && id != null){
      Get.toNamed(routeName, arguments: RxInt(int.parse(id)), preventDuplicates: false);
    }
  }

  Future<Uri> makeDynamicLink(String routeName, String id) async{
    final AndroidParameters androidParameters = AndroidParameters(
        packageName: _android,
        minimumVersion: 1
    );

    final IOSParameters iosParameters = IOSParameters(
        bundleId: _ios,
        appStoreId: _appStoreId,
        minimumVersion: '1'
    );

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: _dynamicLink,
      link: Uri.parse('$_dynamicLink/test?routeName=$routeName&id=$id'),
      androidParameters: androidParameters,
      iosParameters: iosParameters,
    );

    final ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    print(dynamicLink.shortUrl);

    return dynamicLink.shortUrl;
  }
}