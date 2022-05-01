import 'package:sqflite/sqflite.dart';
import 'package:thepuppyplace_flutter/config/local_db.dart';
import 'package:thepuppyplace_flutter/models/BoardCategory.dart';

class BoardCategorySQL with LocalConfig{

  Future INSERT_BANNER() async{
    Database db = await database;
    await db.rawInsert('''
    INSERT INTO ${BoardCategory.TABLE}(
    ${BoardCategory.CATEGORY},
    ${BoardCategory.IMAGE_URL},
    ) 
    VALUES(?, ?)
    ''',
    []
    );
  }
}