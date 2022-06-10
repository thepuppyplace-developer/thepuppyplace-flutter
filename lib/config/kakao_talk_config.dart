import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:thepuppyplace_flutter/models/Board.dart';

class KakaoTalkConfig{
  static const String nativeKey = 'aef15b848194c128efdf92ccd03b5fcf';

  static Future kakaoShareToBrowser(Board board) async{
    try{
      if(await LinkClient.instance.isKakaoLinkAvailable()){
        final FeedTemplate template = FeedTemplate(
          content: Content(
            title: board.title,
            description: board.description,
            imageUrl: Uri.parse(board.board_photos.first),
            link: Link()
          )
        );
        final Uri uri = await WebSharerClient.instance.defaultTemplateUri(template: template);
        return launchBrowserTab(uri);
      } else {

      }
    } catch(error){
      throw Exception(error);
    }
  }

  static Future kakaoShareToMobile(Board board) async{
    try{
      if(await LinkClient.instance.isKakaoLinkAvailable()){
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
        final Uri uri = await LinkClient.instance.defaultTemplate(template: feedTemplate);
        return LinkClient.instance.launchKakaoTalk(uri);
      } else {
        return kakaoShareToBrowser(board);
      }
    } catch(error){
      throw Exception(error);
    }
  }
}