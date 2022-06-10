import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:thepuppyplace_flutter/models/Board.dart';

class KakaoTalkConfig{
  static const String NATIVE_KEY = 'aef15b848194c128efdf92ccd03b5fcf';
  static const String JAVA_SCRIPT_KEY = 'f577fd1aebc884cbe0b0176ceeaa50e2';

  static Future kakaoShareToBrowser(Board board) async{
    try{
      final Uri uri;
      if(board.board_photos.isNotEmpty){
        final FeedTemplate template = FeedTemplate(
            content: Content(
              title: board.title,
              description: board.description,
              imageUrl: Uri.parse(board.board_photos.first),
              link: Link(
                  androidExecutionParams: {},
                  iosExecutionParams: {}
              ),
            ),
            buttonTitle: 'The Puppy Place 실행'
        );
        uri = await WebSharerClient.instance.defaultTemplateUri(template: template);
      } else {
        final TextTemplate template = TextTemplate(
            text: board.title,
            link: Link(
                androidExecutionParams: {},
                iosExecutionParams: {}
            ),
            buttonTitle: 'The Puppy Place 실행'
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
        if(board.board_photos.isNotEmpty){
          final FeedTemplate feedTemplate = FeedTemplate(
              content: Content(
                  title: board.title,
                  description: board.description,
                  imageUrl: Uri.parse(board.board_photos.first),
                  link: Link(
                      androidExecutionParams: {
                      },
                      iosExecutionParams: {

                      }
                  )
              )
          );
          uri = await LinkClient.instance.defaultTemplate(template: feedTemplate);
        } else {
          final TextTemplate template = TextTemplate(
              text: board.title,
              link: Link(
                  androidExecutionParams: {},
                  iosExecutionParams: {}
              ),
              buttonTitle: 'The Puppy Place 실행'
          );
          uri = await WebSharerClient.instance.defaultTemplateUri(template: template);
        }
        return LinkClient.instance.launchKakaoTalk(uri);
      } else {
        return kakaoShareToBrowser(board);
      }
    } catch(error){
      throw Exception(error);
    }
  }

  static Future kakaoLogin() async{
    try{
      final OAuthToken token = await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);
      final User user = await UserApi.instance.me();
      print(user.kakaoAccount?.email);
    } catch(error){
      Exception(error);
    }
  }
}