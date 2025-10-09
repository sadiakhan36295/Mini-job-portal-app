import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../services/db_service.dart';

class AppliedProvider extends ChangeNotifier {
  List<Job> applied = [];
  bool loading = false;

  AppliedProvider() {
    loadApplied();
  }

  Future<void> loadApplied() async {
    loading = true;
    notifyListeners();
    await SavedJobsDatabase.init();
    applied = await SavedJobsDatabase.getAppliedJobs();
    loading = false;
    notifyListeners();
  }

  Future<void> addApplied(Job job) async {
    final exists = await SavedJobsDatabase.appliedExists(job.id);
    if (!exists) {
      await SavedJobsDatabase.insertAppliedJob(job);
      await loadApplied(); // reload and notify
    }
  }

  Future<void> removeApplied(int id) async {
    await SavedJobsDatabase.deleteAppliedJob(id);
    await loadApplied();
  }

  bool isApplied(int id) => applied.any((j) => j.id == id);
}