import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:theahert/models/models.dart';

class SQLiteDatabase {
  const SQLiteDatabase();

  Future<Database> _getDatabase() async {
    return await initDatabase();
  }

  initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "assets/database/users.db");

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data =
        await rootBundle.load(join("assets", "database", "users.db"));

    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);

    Database db = await openDatabase(path, readOnly: true);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT NOT NULL, lastName TEXT NOT NULL, email TEXT NOT NULL, phoneNumber TEXT, userType TEXT NOT NULL)");
  }

  Future<UserTheahert?> createUser(UserTheahertData data) async {
    try {
      final Database db = await _getDatabase();
      final int id = await db.insert(
        "users",
        data.toJson(),
      );
      final List<Map<String, dynamic>> maps = await db.query(
        "users",
        where: "id = ?",
        whereArgs: [id],
      );
      return UserTheahert.fromJson(maps.first["id"].toString(), maps.first);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<void> deleteUsers() async {
    try {
      final Database db = await _getDatabase();
      await db.rawDelete("DELETE FROM users");
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future<void> deleteUserById(String id) async {
    try {
      final Database db = await _getDatabase();
      await db.delete(
        "users",
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future<List<UserTheahert>?> selectUsers() async {
    try {
      final Database db = await _getDatabase();
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
