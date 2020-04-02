

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  //Instance database
  Database _database;
  //Database name
  String _dbName = "polymakers.db";

  //Getter database
  Future<Database> get database async {
    //if database is not exists
    //then create new one
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //initialization database
  Future<Database> initializeDatabase() async {
    //Mengambil lokasi database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/${_dbName}";
    print(path);

    //Membuka database
    var database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
  }


  //Function to create database table
  void _createDB(Database db, int newVersion) async {
    await db.execute('''CREATE TABLE polygon (id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT)''');

    await db.execute('''CREATE TABLE location (id INTEGER PRIMARY KEY AUTOINCREMENT,
      latitude DOUBLE, longitude DOUBLE, polygon_id INTEGER)''');
  } 

}