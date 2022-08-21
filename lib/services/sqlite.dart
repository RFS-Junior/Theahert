import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:theahert/models/models.dart';

class SQLiteDatabase {
  const SQLiteDatabase();

  Future<Database> _getDatabase(String databaseName) async {
    return await initDatabase(databaseName);
  }

  initDatabase(String databaseName) async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT NOT NULL, lastName TEXT NOT NULL, email TEXT NOT NULL, phoneNumber TEXT, userType TEXT NOT NULL)");
  }

  Future create(UserTheahertData data) async {
    try {
      final Database db = await _getDatabase("theahert");

      await db.insert(
        "users",
        data.toJson(),
      );
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future deleteAll() async {
    try {
      final Database db = await _getDatabase("theahert");

      await db.rawDelete("DELETE FROM users");
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future<List<UserTheahert>?> getAllUsers() async {
    try {
      final Database db = await _getDatabase("theahert");

      return await db.query("users", columns: [
        "id",
        "lastName",
        "lastName",
        "email",
        "phoneNumber",
        "userType"
      ]).then((value) {
        for (var element in value) {
          UserTheahert.fromJson(element["id"].toString(), element);
        }
      });
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<List<UserTheahert>?> getUsers() async {
    try {
      final Database db = await _getDatabase("theahert");
      final List<Map<String, dynamic>> maps = await db.query("users");

      return List.generate(
        maps.length,
        (i) {
          return UserTheahert.fromJson(maps[i]["id"].toString(), maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return null;
    }
  }
}
