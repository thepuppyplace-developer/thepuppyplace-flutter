import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../.local_db.dart';
import '../../models/Search.dart';

class SearchRepository with LocalDB{
  Database? _db;

  Future<Database> get db async{
    if(_db != null){
      return _db!;
    } else {
      return openDatabase(join(await getDatabasesPath(), 'thepuppyplace'),
        version: version,
        onCreate: (Database db, int version){
        db.execute(createSearchTable);
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