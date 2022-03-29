import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../.config.dart';
import '../../.local_db.dart';
import '../../models/Board.dart';

class BoardRepository extends GetConnect with Config, LocalDB{
  Future<Database> get db async{
    return openDatabase(join(await getDatabasesPath(), dbName),
      version: version,
      onCreate: (Database db, int version) async{

      }
    );
  }

  Future<List<Board>> findAllBoard() async{
    Response res = await get('$API_URL/board');

    switch(res.statusCode){
      case 200: {
        return List.from(res.body['data']).map((data) => Board.fromJson(data)).toList();
      }
      case 204: {
        return <Board>[];
      }
      case 500: {
        return <Board>[];
      }
      default: {
        showToast('인터넷 연결을 해주세요.');
        return <Board>[];
      }
    }
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