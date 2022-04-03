import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thepuppyplace_flutter/models/Search.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../.config.dart';
import '../../.local_db.dart';
import '../../models/Board.dart';
import '../database_controller.dart';

class BoardRepository extends GetConnect with Config, LocalDB{

  Future<RefreshStatus> refreshBoardList() async{
    Database db = await DatabaseController.to.db;
    SharedPreferences spf = await DatabaseController.spf;
    String? refreshDate = spf.getString('boardRefreshDate');

    Response res = await post('$API_URL/board', {
      // 'refreshDate': refreshDate ?? DateTime(2000).toIso8601String()
      'refreshDate': DateTime(2000).toIso8601String()
    });

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
        if(boardList.isNotEmpty){
          await spf.setString('boardRefreshDate', DateTime.now().toIso8601String());
          return RefreshStatus.completed;
        } else {
          return RefreshStatus.idle;
        }
      }
      default: {
        return RefreshStatus.failed;
      }
    }
  }

  Future<RefreshStatus> refreshBoard(int board_id) async{
    Database db = await DatabaseController.to.db;
    Response res = await get('$API_URL/board/$board_id');

    switch(res.statusCode){
      case 200: {
        Board board = Board.fromJson(res.body['data']);
        List<Board> boardList = List.from(await db.query(boardTable, where: 'id = ?', whereArgs: [board.id])).map((board) => Board.fromDatabase(board)).toList();
        if(boardList.isEmpty){
          await db.insert(boardTable, board.toJson());
        } else {
          await db.update(boardTable, board.toJson(), where: 'id = ?', whereArgs: [board_id]);
        }
        return RefreshStatus.completed;
      }
      default: {
        return RefreshStatus.failed;
      }
    }
  }

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

  Future<List<Board>> boardList(int limit) async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable,
        orderBy: 'id DESC',
        limit: limit
    );
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> cafeBoardList(int limit) async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable,
        orderBy: 'id DESC',
        where: 'category = ?',
        whereArgs: ['카페'],
        limit: limit
    );
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> restaurantBoardList(int limit) async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable,
      orderBy: 'id DESC',
      where: 'category = ?',
      whereArgs: ['음식점'],
      limit: limit
    );
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> shoppingBoardList(int limit) async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable,
        orderBy: 'id DESC',
        where: 'category = ?',
        whereArgs: ['쇼핑몰'],
        limit: limit
    );
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> hotelBoardList(int limit) async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable,
        orderBy: 'id DESC',
        where: 'category = ?',
        whereArgs: ['호텔'],
        limit: limit
    );
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> groundBoardList(int limit) async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable,
        orderBy: 'id DESC',
        where: 'category = ?',
        whereArgs: ['운동장'],
        limit: limit
    );
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Board>> talkBoardList(int limit) async{
    Database db = await DatabaseController.to.db;
    final boardList = await db.query(boardTable,
        orderBy: 'id DESC',
        where: 'category = ?',
        whereArgs: ['수다방'],
        limit: limit
    );
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<Board?> findOneBoard(int board_id) async{
    Database db = await DatabaseController.to.db;
    Board board = List.from(await db.query(boardTable, where: 'id = ? ', whereArgs: [board_id])).map((board) => Board.fromDatabase(board)).first;
    return board;
  }

  Future<List<Board>> searchBoardList(String keyword) async{
    Database db = await DatabaseController.to.db;

    List<Search> searchList = List.from(await db.query(searchTable, where: 'keyword = ?', whereArgs: [keyword])).map((search) => Search.fromJson(search)).toList();
    if(searchList.isEmpty){
      await db.insert(searchTable, Search(keyword: keyword).toJson());
    }
    final boardList = await db.query(boardTable,
        where: 'title LIKE "%$keyword%" or description LIKE "%$keyword%"',
        whereArgs: ['%$keyword%', '%$keyword%'],
        limit: 10
    );
    return boardList.map((board) => Board.fromDatabase(board)).toList();
  }

  Future<List<Search>> searchList() async{
    Database db = await DatabaseController.to.db;
    final searchList = await db.query(searchTable);
    return searchList.map((search) => Search.fromJson(search)).toList();
  }

  Future deleteSearch(int id) async{
    Database db = await DatabaseController.to.db;
    await db.delete(searchTable, where: 'id = ?', whereArgs: [id]);
  }
}