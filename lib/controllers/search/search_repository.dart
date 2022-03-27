import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../.config.dart';
import '../../models/Search.dart';

class SearchRepository with Config{
  Database? _db;

  Future<Database> get db async{
    if(_db != null){
      return _db!;
    } else {
      return openDatabase(join(await getDatabasesPath(), 'thepuppyplace'),
        version: sqliteVersion,
        onCreate: (Database db, int version){
        db.execute('''
        CREATE TABLE Search(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        keyword TEXT NOT NULL,
        createdAT DATETIME NOT NULL
        )
        ''');
        }
      );
    }
  }

  Future<List<Search>> findAllSearch() async{
    Database database = await db;

    List<Map<String, dynamic>> searchList = await database.query('Search');

    return List.from(searchList).map((search) => Search.fromJson(search)).toList();
  }
}