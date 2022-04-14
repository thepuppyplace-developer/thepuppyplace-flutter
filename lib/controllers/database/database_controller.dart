import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../config/local_db.dart';

class DatabaseController extends GetxController with LocalDB{
  static DatabaseController get to => DatabaseController();

  Future<Database> get db async{
    return openDatabase(join(await getDatabasesPath(), dbName),
      version: version,
      onCreate: (Database db, int version) async{
      await db.execute(CREATE_SEARCH_TABLE);
      await db.execute(CREATE_USER_TABLE);
      await db.execute(CREATE_BOARD_CATEGORY_TABLE);
      }
    );
  }

  @override
  void onInit() async{
    super.onInit();
    await db;
  }
}