// data_base.dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'json_profile.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'profiles.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE profiles(id INTEGER PRIMARY KEY, name TEXT, email TEXT, phone TEXT, address TEXT, bloodGroup TEXT)',
    );
  }

  Future<int> saveProfile(Profile profile) async {
    Database db = await database;
    return await db.insert('profiles', profile.toMap());
  }

  Future<int> updateProfile(Profile profile) async {
    Database db = await database;
    return await db.update('profiles', profile.toMap(), where: 'id = ?', whereArgs: [profile.id]);
  }

  Future<Profile?> getProfile(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('profiles', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Profile.fromMap(maps.first);
    }
    return null;
  }
}
