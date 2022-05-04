import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/user.dart';


class SQLHelper {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstName TEXT,
        lastName TEXT,
        gender TEXT,
        phone TEXT,
        adresse TEXT,
        mail TEXT,
        birthday TEXT,
        citation TEXT,
        photo TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'sqlTpDb.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<User> createUser(User user) async {
    final db = await SQLHelper.db();
    user.setId(await db.insert('users', user.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace));
    return user;
  }

  static Future<List<User>> getUsers() async {
    List<Map<String, dynamic>> jsons =[];
    List<User> users =[];
    final db = await SQLHelper.db();
    jsons = await db.query('users', orderBy: "id");

    if(jsons.length>0){
      for(int i = 0; i<jsons.length; i++){
          users.add(User.fromJson(jsons[i]));
      }
    }

    return users;
  }

  static Future<User> getUser(User user) async {
    List<Map<String,dynamic>> jsons =[];
    Map<String,dynamic> json ={};
    final db = await SQLHelper.db();
    jsons = await db.query('users', where: "id = ?", whereArgs: [user.getId()], limit: 1);
    if(jsons.length>0){
      json = jsons[0];
      user = User.fromJson(json);
    }
    return user;

  }


  static Future<User> updateUser(User user) async {
    final db = await SQLHelper.db();
    await db.update('users', user.toJson(), where: "id = ?", whereArgs: [user.getId()]);
    return user;
  }
  static Future<void> deleteUser(User user) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("users", where: "id = ?", whereArgs: [user.getId()]);
    } catch (err) {
      debugPrint("Quelque chose s'est mal passé lors de la suppression : $err");
    }
  }
}