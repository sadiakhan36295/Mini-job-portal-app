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

    // Use version 2 to include applied_jobs table (if upgrading from v1 -> v2 we create applied table)
    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        // fresh install -> create both tables
        await db.execute('''
          CREATE TABLE saved_jobs (
            id INTEGER PRIMARY KEY,
            job_json TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE applied_jobs (
            id INTEGER PRIMARY KEY,
            job_json TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Upgrade path: if older version did not have applied_jobs, create it now
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS applied_jobs (
              id INTEGER PRIMARY KEY,
              job_json TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  // ---------------- SAVED JOBS ----------------
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

  // ---------------- APPLIED JOBS ----------------
  static Future<List<Job>> getAppliedJobs() async {
    final db = _db!;
    final rows = await db.query('applied_jobs');
    return rows.map((r) {
      final jsonMap = jsonDecode(r['job_json'] as String) as Map<String, dynamic>;
      return Job.fromJson(jsonMap);
    }).toList();
  }

  static Future<void> insertAppliedJob(Job job) async {
    final db = _db!;
    await db.insert(
      'applied_jobs',
      {'id': job.id, 'job_json': jsonEncode(job.toJson())},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteAppliedJob(int id) async {
    final db = _db!;
    await db.delete('applied_jobs', where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> appliedExists(int id) async {
    final db = _db!;
    final rows = await db.query('applied_jobs', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }
}