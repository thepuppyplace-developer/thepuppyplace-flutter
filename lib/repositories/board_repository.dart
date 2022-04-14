import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../config/local_db.dart';
import '../../models/Board.dart';
import '../models/BoardComment.dart';
import '../pages/insert_page/insert_page.dart';

class BoardRepository extends GetConnect with Config, LocalDB{
  static BoardRepository get from => BoardRepository();

  Future insertBoard(BuildContext context, {
    required String title,
    required String description,
    required String location,
    required String category,
}) async{
    SharedPreferences spf = await SharedPreferences.getInstance();
    String? jwt = spf.getString('jwt');
    String message;
    if(jwt != null){
      Response res = await post('$API_URL/board/insert', FormData({
        'title': title.trim(),
        'description': description.trim(),
        'location': location.trim(),
        'category': category.trim(),
      }), headers: headers(jwt));
      switch(res.statusCode){
        case 201: {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BoardDetailsPage(res.body['data']['id'])), (route) => route.isFirst);
          message = '성공적으로 게시되었습니다.';
          break;
        }
        default: {
          message = '네트워크를 확인해주세요.';
        }
      }
    } else {
      message = '토큰이 만료되었습니다.';
    }
    return showSnackBar(context, message);
  }

  Future<List<Board>> getBoardList({required int page, String? category , String? order}) async{
    Response res = await post('$API_URL/board', {
      'page': page,
      'category': category,
      'order': order,
    });

    switch(res.statusCode){
      case 200: {
        return List.from(res.body['data']).map((board) => Board.fromJson(board)).toList();
      }
      default: {
        return [];
      }
    }
  }

  Future<Board?> getBoard(int board_id) async{
    Response res = await get('$API_URL/board/$board_id');

    switch(res.statusCode){
      case 200: {
        return Board.fromJson(res.body['data']);
      }
      default: {
        return null;
      }
    }
  }

  Future insertComment(BuildContext context, BoardComment comment) async{
    if(await jwt != null){
      Response res = await post('$API_URL/comment', comment.toJson(), headers: headers(await jwt));
      switch(res.statusCode){
        case 201: return showSnackBar(context, '성공적으로 게시되었습니다.');
        default: return network_check(context);
      }
    } else {
      return expiration_token(context);
    }
  }
}