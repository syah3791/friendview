import 'dart:async';
import 'dart:io';

import 'package:friendview/models/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UserModelDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          Batch batch = db.batch();
          batch.execute("CREATE TABLE Users ("
              "id INTEGER PRIMARY KEY,"
              "name TEXT,"
              "age INTEGER,"
              "location INTEGER,"
              "description TEXT,"
              "image TEXT"
              ")");
          batch.execute("CREATE TABLE Personal ("
              "id INTEGER PRIMARY KEY,"
              "id_user TEXT,"
              "created_at TEXT"
              ")");
          List<dynamic> res = await batch.commit();
        });
  }

  newUserModel(UserModel newUserModel) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM Users");
    int id = (table.first["id"] ?? 1) as int;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Users (id, name, age, location, description, image)"
            " VALUES (?,?,?,?,?,?)",
        [id, newUserModel.name, newUserModel.age, newUserModel.location,
          newUserModel.description, newUserModel.image]);
    return id;
  }

  updateUserModel(UserModel newUserModel) async {
    final db = await database;
    var res = await db!.update("Users", newUserModel.toJson(),
        where: "id = ?", whereArgs: [newUserModel.id]);
    return res;
  }

  getNewFriends() async {
    final db = await database;
    var table = await db!.rawQuery("SELECT Users.* FROM Users LEFT JOIN Personal ON Users.id = Personal.id_user");
    print(table);
    List<UserModel> list =
    table.isNotEmpty ? table.map((c) => UserModel.fromJson(c)).toList() : [];
    return list;
  }

  getAllUserModels() async {
    final db = await database;
    var res = await db!.query("Users");
    List<UserModel> list =
    res.isNotEmpty ? res.map((c) => UserModel.fromJson(c)).toList() : [];
    return list;
  }

  getUserEmpty() async {
    final db = await database;
    var res = await db!.rawQuery("SELECT * FROM Users", null);
    return res.length > 0 ? false : true;
  }

  getLastFriend() async {
    final db = await database;
    var data = await db!.rawQuery("SELECT Users.* FROM Users JOIN Personal ON Users.id = Personal.id_user ORDER BY Personal.created_at DESC LIMIT 1");
    return data.length > 0 ? UserModel.fromJson(data[0]) : null;
  }

  deleteUserModel(int id) async {
    final db = await database;
    return db!.delete("Personal", where: "id = ?", whereArgs: [id]);
  }

  newPersonal(int id_user) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM Personal");
    int id = (table.first["id"] ?? 1) as int;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Personal (id, id_user, created_at)"
            " VALUES (?,?,?)",
        [id, id_user, DateTime.now().toString()]);
    return id;
  }

  deleteAllMyFriend() async {
    final db = await database;
    db!.rawDelete("Delete * from Personal");
  }
}