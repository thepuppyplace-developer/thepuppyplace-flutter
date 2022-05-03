import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../config/local_config.dart';
import '../../models/User.dart';

class UserSQLRepo extends LocalConfig{

  Future<List<User>> QUERY_USER_ID(int id) async{
    try{
      final Database db = await database;
      final userList = await db.rawQuery('SELECT * FROM ${User.TABLE} WHERE ${User.ID} = ?', [id]);
      return userList.map((user) => User.fromJson(user)).toList();
    } catch(error){
      throw Exception(error);
    }
  }

  Stream<User?> get GET_USER async*{
    try{
      final Database db = await database;
      final userStream = db.rawQuery('SELECT * FROM ${User.TABLE}').asStream();
      yield* userStream.map((users){
        if(users.isNotEmpty){
          return users.map((user) => User.fromJson(user)).first;
        } else {
          return null;
        }
      });
    } catch(error){
      throw Exception(error);
    }
  }

  Future REFRESH_USER(User user) async{
    try{
      final Database db = await database;
      final List<User> userList = await QUERY_USER_ID(user.id);

      if(userList.isNotEmpty){
        return db.insert(User.TABLE, user.toJson());
      } else {
        return db.update(User.TABLE, user.toJson(),
            where: 'WHERE ${User.ID} = ?',
            whereArgs: [user.id]
        );
      }
    } catch(error){
      throw Exception(error);
    }
  }

  Future UPDATE_USER_COLUMNS({required String columns, required Object values, required int user_id}) async{
    try{
      final Database db = await database;
      final List<User> userList = await QUERY_USER_ID(user_id);

      if(userList.isNotEmpty){
        return db.rawUpdate('''
      UPDATE ${User.TABLE} 
      SET $columns = ?
      WHERE ${User.ID} = ?
      ''', [values, user_id]);
      }
      return;
    } catch(error){
      throw Exception(error);
    }
  }

  Future LOGOUT(int user_id) async{
    try{
      final Database db = await database;
      final List<User> userList = await QUERY_USER_ID(user_id);
      if(userList.isNotEmpty){
        await db.rawDelete('''
          DELETE FROM ${User.TABLE}
          WHERE ${User.ID} = ?
          ''', [user_id]);
      }
      return;
    } catch(error){
      throw Exception(error);
    }
  }
}