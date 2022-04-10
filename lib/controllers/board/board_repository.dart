import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../config/local_db.dart';
import '../../models/Board.dart';

class BoardRepository extends GetConnect with Config, LocalDB{
  Future insertComment({required int board_id, required int user_id, required String comment}) async{
    Response res = await post('$API_URL/comment', {
      'board_id': board_id,
      'user_id': user_id,
      'comment': comment
    });

    switch(res.statusCode){
      case 201: {
        return showToast('댓글을 성공적으로 등록했습니다');
      }
      default: {
        return showToast('인터넷 연결을 해주세요');
      }
    }
  }

  Future<List<Board>> getBoardList(List<Board> boardList, int page) async{
    Response res = await post('$API_URL/board', {
      'page': page,
      'view': 'view'
    });

    switch(res.statusCode){
      case 200: {
        boardList.addAll(List.from(res.body['data']).map((board) => Board.fromJson(board)).toList());
        return boardList;
      }
      default: {
        return [];
      }
    }
  }

  Future<List<Board>> refreshCategoryBoardList({required int page, required String category, required String order}) async{
    Response res = await post('$API_URL/board', {
      'page': page,
      'category': category,
      'order': order
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

  Future<List<Board>> categoryBoardList(List<Board> boardList, {required int page, required String category, required String order}) async{
    Response res = await post('$API_URL/board', {
      'page': page,
      'category': category,
      'order': order
    });

    switch(res.statusCode){
      case 200: {
        boardList.addAll(List.from(res.body['data']).map((board) => Board.fromJson(board)).toList());
        return boardList;
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
}