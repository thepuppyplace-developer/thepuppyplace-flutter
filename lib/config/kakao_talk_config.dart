import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:thepuppyplace_flutter/config/dynamic.config.dart';
import 'package:thepuppyplace_flutter/models/Board.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';

class KakaoTalkConfig{
  static final String NATIVE_KEY = dotenv.get('KAKAO_NATIVE_KEY');
  static final String JAVA_SCRIPT_KEY = dotenv.get('KAKAO_JAVA_SCRIPT_KEY');

  static Future kakaoShareToBrowser(Board board) async{
    try{
      final Uri uri;
      final Uri dynamicLink = await DynamicConfig.instance.makeDynamicLink(BoardDetailsPage.routeName, board.id.toString());

      if(board.board_photos.isNotEmpty){
        final FeedTemplate template = FeedTemplate(
            content: Content(
              title: board.title,
              description: board.description,
              imageUrl: Uri.parse(board.board_photos.first),
              link: Link(
                  mobileWebUrl: dynamicLink
              ),
            ),
        );
        uri = await WebSharerClient.instance.defaultTemplateUri(template: template);
      } else {
        final TextTemplate template = TextTemplate(
            text: board.title,
            link: Link(
                mobileWebUrl: dynamicLink
            ),
        );
        uri = await WebSharerClient.instance.defaultTemplateUri(template: template);
      }
      return launchBrowserTab(uri);
    } catch(error){
      throw Exception(error);
    }
  }

  static Future kakaoShareToMobile(Board board) async{
    try{
      if(await LinkClient.instance.isKakaoLinkAvailable()){
        final Uri uri;
        final Uri dynamicLink = await DynamicConfig.instance.makeDynamicLink(BoardDetailsPage.routeName, board.id.toString());
        if(board.board_photos.isNotEmpty){
          final FeedTemplate feedTemplate = FeedTemplate(
              content: Content(
                  title: board.title,
                  description: board.description,
                  imageUrl: Uri.parse(board.board_photos.first),
                  link: Link(
                    mobileWebUrl: dynamicLink,
                  )
              )
          );
          uri = await LinkClient.instance.defaultTemplate(template: feedTemplate);
        } else {
          final TextTemplate template = TextTemplate(
              text: board.title,
              link: Link(
                  mobileWebUrl: dynamicLink
              ),
              buttonTitle: 'The Puppy Place 실행'
          );
          uri = await LinkClient.instance.defaultTemplate(template: template);
        }
        return LinkClient.instance.launchKakaoTalk(uri);
      } else {
        return kakaoShareToBrowser(board);
      }
    } catch(error){
      throw Exception(error);
    }
  }

  static Future<User> kakaoLogin() async{
    try{
      final OAuthToken token;
      final User user;
      if(await LinkClient.instance.isKakaoLinkAvailable()){
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      user = await UserApi.instance.me();
      return user;
    } catch(error){
      throw Exception(error);
    }
  }
}