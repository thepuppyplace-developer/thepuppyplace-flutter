import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/BoardCategory.dart';
import '../models/User.dart';

class LocalConfig{
  final String dbName = 'test37';
  final int version = 1;

  Future<Database> get database async{
    return openDatabase(join(await getDatabasesPath(), dbName),
        version: version,
        onCreate: (Database db, int version) async{
          await db.execute(User.CREATE_TABLE);
          await db.execute(BoardCategory.CREATE_TABLE);
          await db.execute(BoardCategory.TRIGGER);
        }
    );
  }

  Future<String?> get jwt async{
    List<User> userList = await USER_LIST();
    if(userList.isNotEmpty){
      return userList.first.jwt_token;
    } else {
      return null;
    }
  }

  Future<List<BoardCategory>> CATEGORY_LIST({String? where, List<Object?>? whereArgs, int? limit, String? orderBy}) async{
    Database db = await database;
    return List.from(await db.query(BoardCategory.TABLE, where: where, whereArgs: whereArgs, limit: limit, orderBy: orderBy)).map((category) => BoardCategory.fromJson(category)).toList();
  }

  Future<List<User>> USER_LIST({String? where, List<Object?>? whereArgs, int? limit, String? orderBy}) async{
    Database db = await database;
    return List.from(await db.query(User.TABLE, where: where, whereArgs: whereArgs, limit: limit, orderBy: orderBy)).map((user) => User.fromJson(user)).toList();
  }
}