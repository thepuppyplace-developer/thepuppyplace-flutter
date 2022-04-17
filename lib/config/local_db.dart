import 'package:sqflite/sqflite.dart';
import '../controllers/database/database_controller.dart';
import '../models/BoardCategory.dart';
import '../models/User.dart';

class LocalDB{
  final String dbName = 'test36';
  final int version = 1;

  Future<Database> get database => DatabaseController.to.db;

  Future<String?> get jwt async{
    List<User> userList = await USER_LIST();
    if(userList.isNotEmpty){
      return userList.first.jwt_token;
    } else {
      return null;
    }
  }

  final String BOARD_CATEGORY_TABLE = 'BoardCategory';
  final String CREATE_BOARD_CATEGORY_TABLE = '''
  CREATE TABLE IF NOT EXISTS BoardCategory(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  category TEXT NOT NULL,
  image_url TEXT NOT NULL,
  createdAT TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  deletedAt TEXT NOT NULL
  )
  ''';
  Future<List<BoardCategory>> CATEGORY_LIST({String? where, List<Object?>? whereArgs, int? limit, String? orderBy}) async{
    Database db = await database;
    return List.from(await db.query(BOARD_CATEGORY_TABLE, where: where, whereArgs: whereArgs, limit: limit, orderBy: orderBy)).map((category) => BoardCategory.fromJson(category)).toList();
  }

  final String SEARCH_TABLE = 'Search';
  final String CREATE_SEARCH_TABLE = '''
  CREATE TABLE Search(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  keyword TEXT NOT NULL UNIQUE,
  createdAT TEXT NOT NULL
  )
  ''';

  final String USER_TABLE = 'User';
  final String CREATE_USER_TABLE = '''
  CREATE TABLE IF NOT EXISTS User(
  id INTEGER PRIMARY KEY NOT NULL,
  email TEXT NOT NULL,
  nickname TEXT NOT NULL,
  name TEXT,
  phone_number TEXT,
  photo_url TEXT,
  gender TEXT,
  fcm_token TEXT,
  jwt_token TEXT,
  is_alarm INTEGER NOT NULL,
  location TEXT,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  deletedAt TEXT
  )
  ''';
  Future<List<User>> USER_LIST({String? where, List<Object?>? whereArgs, int? limit, String? orderBy}) async{
    Database db = await database;
    return List.from(await db.query(USER_TABLE, where: where, whereArgs: whereArgs, limit: limit, orderBy: orderBy)).map((user) => User.fromJson(user)).toList();
  }
}