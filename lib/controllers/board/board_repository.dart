import 'package:get/get.dart';
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
          if(List.from(await db.query(boardTable, where: 'id = ?', whereArgs: [board.id])).isEmpty){
            await db.insert(boardTable, board.toJson());
          } else if(board.deletedAt != null){
            await db.delete(boardTable, where: 'id = ?', whereArgs: [board.id]);
          } else {
            await db.update(boardTable, board.toJson(), where: 'id = ?', whereArgs: [board.id]);
          }
        }
        return print('refreshed-boardList');
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

  Future<List<Board>> get cafeBoardList async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable, orderBy: 'id DESC', where: 'category = ?', whereArgs: ['카페']);
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> get restaurantBoardList async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable, orderBy: 'id DESC', where: 'category = ?', whereArgs: ['음식점']);
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> get shoppingBoardList async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable, orderBy: 'id DESC', where: 'category = ?', whereArgs: ['쇼핑몰']);
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> get hotelBoardList async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable, orderBy: 'id DESC', where: 'category = ?', whereArgs: ['호텔']);
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> get groundBoardList async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable, orderBy: 'id DESC', where: 'category = ?', whereArgs: ['운동장']);
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> get talkBoardList async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable, orderBy: 'id DESC', where: 'category = ?', whereArgs: ['수다방']);
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