import 'dart:developer';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBOperations extends GetxController {
  late Database _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "chat_app1.db"),
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE IF NOT EXISTS friends_list(
          username TEXT NOT NULL,
          userId TEXT NOT NULL
        )
      ''');
      },
      version: 1,
    );
  }

  Future<void> insertData(FriendsList friendsList) async {
    try {
      int result = await _database.insert(
        'friends_list',
        friendsList.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (result != -1) {
        log("Data added..");
      } else {
        log("Data adding failed..");
      }
    } catch (e) {
      log("Data adding failed $e");
    }
  }

  Future<List<FriendsList>> getFriendsList() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('friends_list');

    return List.generate(maps.length, (i) {
      return FriendsList(
          userId: maps[i]['userId'], username: maps[i]['username']);
    });
  }

  Future<void> deleteData(String id) async {
    try {
      await _database.delete(
        'friends_list',
        where: 'userId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      log('Error while removing $e');
    }
  }

  Future<bool> checkUserIsExists(String userId) async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query(
        'friends_list',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      return maps.isNotEmpty;
    } catch (e) {
      log("Error occurred while checking attractionId existence: $e");
      return false;
    }
  }
}

class FriendsList {
  final String username;
  final String userId;

  FriendsList({
    required this.username,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userId': userId,
    };
  }
}
