import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/job_model.dart';

class SavedJobsDatabase {
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'saved_jobs.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE saved_jobs (
            id INTEGER PRIMARY KEY,
            job_json TEXT
          )
        ''');
      },
    );
  }

  static Future<List<Job>> getSavedJobs() async {
    final db = _db!;
    final rows = await db.query('saved_jobs');
    return rows.map((r) {
      final jsonMap = jsonDecode(r['job_json'] as String) as Map<String, dynamic>;
      return Job.fromJson(jsonMap);
    }).toList();
  }

  static Future<void> insertJob(Job job) async {
    final db = _db!;
    await db.insert(
      'saved_jobs',
      {'id': job.id, 'job_json': jsonEncode(job.toJson())},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteJob(int id) async {
    final db = _db!;
    await db.delete('saved_jobs', where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> exists(int id) async {
    final db = _db!;
    final rows = await db.query('saved_jobs', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }
}
