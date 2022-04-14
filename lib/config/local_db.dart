import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../controllers/database/database_controller.dart';
import '../models/User.dart';

class LocalDB{
  final String dbName = 'test34';
  final int version = 1;

  Future<Database> get database => DatabaseController.to.db;

  Future<String?> get jwt async{
    SharedPreferences spf = await SharedPreferences.getInstance();
    return spf.getString('jwt');
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
  email TEXT,
  password TEXT,
  nickname TEXT,
  name TEXT,
  phone_number TEXT,
  photo_url TEXT,
  gender TEXT,
  fcm_token TEXT,
  is_alarm INTEGER,
  location TEXT,
  createdAt TEXT,
  updatedAt TEXT,
  deletedAt TEXT
  )
  ''';
  Future<List<User>> get userList async{
    Database db = await database;
    return List.from(await db.query(USER_TABLE)).map((user) => User.fromJson(user)).toList();
  }

  final String BOARD_CATEGORY_TABLE = 'BoardCategory';
  final String CREATE_BOARD_CATEGORY_TABLE = '''
  CREATE TABLE IF NOT EXISTS BoardCategory(
  id INTEGER PRIMARY KEY NOT NULL,
  category TEXT NOT NULL,
  image_url TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  deletedAt TEXT
  )
  ''';
}