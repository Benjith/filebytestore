import 'dart:io';

import 'package:filebytestore/core/app_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, AppConstants.dbName);
    // Open the database, can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: AppConstants.kVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${AppConstants.tableName} (
            ${AppConstants.columnId} INTEGER PRIMARY KEY,
            ${AppConstants.columnName} TEXT NOT NULL,
            ${AppConstants.columnDob} TEXT NOT NULL,
            ${AppConstants.columnEmployeeId} TEXT NOT NULL UNIQUE,
            ${AppConstants.columnImgUrl} TEXT NULL,
            ${AppConstants.columnNationality} TEXT NOT NULL
          )
          ''');
  }

  // Database helper methods:

  // Future<int> insert(Word word) async {
  //   Database db = await database;
  //   int id = await db.insert(tableWords, word.toMap());
  //   return id;
  // }

  // Future<Word> queryWord(int id) async {
  //   Database db = await database;
  //   List<Map> maps = await db.query(tableWords,
  //       columns: [columnId, columnWord, columnFrequency],
  //       where: '$columnId = ?',
  //       whereArgs: [id]);
  //   if (maps.length > 0) {
  //     return Word.fromMap(maps.first);
  //   }
  //   return null;
  // }

  // Future<List<Word>> queryAllWords() async {
  //   Database db = await database;
  //   List<Map> maps = await db.query(tableWords);
  //   if (maps.length > 0) {
  //     List<Word> words = [];
  //     maps.forEach((map) => words.add(Word.fromMap(map)));
  //     return words;
  //   }
  //   return null;
  // }

  // Future<int> deleteWord(int id) async {
  //   Database db = await database;
  //   return await db.delete(tableWords, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Future<int> update(Word word) async {
  //   Database db = await database;
  //   return await db.update(tableWords, word.toMap(),
  //       where: '$columnId = ?', whereArgs: [word.id]);
  // }
}
