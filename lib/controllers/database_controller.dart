import 'package:get/get.dart';
import 'package:path/path.dart';
import '../.local_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseController extends GetxController with LocalDB{
  static DatabaseController get to => DatabaseController();

  Future<Database> get db async{
    return openDatabase(join(await getDatabasesPath(), dbName),
      version: version,
      onCreate: (Database db, int version) async{
      await db.execute(createSearchTable);
      await db.execute(createBoardTable);
      }
    );
  }

  @override
  void onInit() async{
    super.onInit();
    await db;
  }
}