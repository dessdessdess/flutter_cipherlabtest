import 'package:flutter_cipherlabtest/model/WorkTask.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  DBService._();

  static final DBService db = DBService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // if _database is null we instantiate it
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'work_tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE workTasks(id INTEGER PRIMARY KEY AUTOINCREMENT, number TEXT, date TEXT, docType TEXT, docTypeInternal TEXT, guid TEXT, client TEXT, completed INTEGER, warehouseGuid TEXT, marks TEXT, goods TEXT, gtins TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertWorkTask(WorkTask workTask) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db
        .query('workTasks', where: 'guid = ?', whereArgs: [workTask.guid]);

    if (maps.isEmpty) {
      await db.insert(
        'workTasks',
        workTask.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<List<WorkTask>> workTasks(DateTime date) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('workTasks',
        where: 'date = ?', whereArgs: [date.toIso8601String()]);

    return List.generate(maps.length, (i) {
      return WorkTask.fromMap(maps[i]);
    });
  }

  Future<void> updateWorktask(WorkTask workTask) async {
    final db = await database;

    await db.update(
      'workTasks',
      workTask.toMap(),
      where: 'guid = ?',
      whereArgs: [workTask.guid],
    );
  }

  Future<List<WorkTask>> completedTasks() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('workTasks', where: 'completed = ?', whereArgs: [1]);

    return List.generate(maps.length, (i) {
      return WorkTask.fromMap(maps[i]);
    });
  }

  Future<int> countOfCompletedTasks() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('workTasks', where: 'completed = ?', whereArgs: [1]);

    return maps.length;
  }

  Future<bool> deleteTask(String guid) async {
    final db = await database;

    final result =
        await db.delete('workTasks', where: 'guid = ?', whereArgs: [guid]);

    if (result > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteTasks(List<WorkTask> workTasks) async {
    var result = false;
    for (var workTask in workTasks) {
      result = await deleteTask(workTask.guid);
    }
    return result;
  }
}
