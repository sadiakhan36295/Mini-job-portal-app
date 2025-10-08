import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/job.dart';

class SavedJobsDatabase {
  static Database? _db;
  static const String DB_NAME = 'saved_jobs.db';
  static const String TABLE = 'saved_jobs';

  static Future<void> init() async {
    if (_db != null) return;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DB_NAME);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE $TABLE (
            id INTEGER PRIMARY KEY,
            json TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> saveJob(Job job) async {
    await _db!.insert(
      TABLE,
      {'id': job.id, 'json': job.toJsonString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeJob(int id) async {
    await _db!.delete(TABLE, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Job>> getSavedJobs() async {
    final List<Map<String, dynamic>> rows = await _db!.query(TABLE);
    return rows.map((r) => Job.fromJsonString(r['json'] as String)).toList();
  }

  static Future<bool> isSaved(int id) async {
    final List<Map<String, dynamic>> rows =
        await _db!.query(TABLE, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }
}
