import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../.config.dart';
import '../../.local_db.dart';
import '../../models/Board.dart';
import '../database_controller.dart';

class BoardRepository extends GetConnect with Config, LocalDB{

  Future refreshBoardList() async{
    Database db = await DatabaseController.to.db;
    Response res = await get('$API_URL/board');

    switch(res.statusCode){
      case 200: {
        List<Board> boardList = List.from(res.body['data']).map((board) => Board.fromJson(board)).toList();
        for(Board board in boardList){
          if(List.from(await db.query(boardTable, where: 'id = ?', whereArgs: [board.boardId])).isEmpty){
            await db.insert(boardTable, board.toJson());
          } else {
            await db.update(boardTable, board.toJson(), where: 'id = ?', whereArgs: [board.boardId]);
          }
        }
        return showToast('updated-boardList');
      }
      default: {
        return showToast('인터넷 연결을 해주세요.');
      }
    }
  }

  Future<List<Board>> get boardList async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable, orderBy: 'id DESC');
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<Board?> findOneBoard(int board_id) async{
    Response res = await get('$API_URL/board/$board_id');

    switch(res.statusCode){
      case 200: {
        return Board.fromJson(res.body['data']);
      }
      case 204: {
        return null;
      }
      case 500: {
        await showToast(res.body['message']);
        return null;
      }
      default: {
        return null;
      }
    }
  }
}