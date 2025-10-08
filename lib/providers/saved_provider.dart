import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../services/db_service.dart';

class SavedProvider extends ChangeNotifier {
  List<Job> saved = [];
  bool loading = false;

  SavedProvider() {
    loadSaved();
  }

  Future<void> loadSaved() async {
    loading = true;
    notifyListeners();
    await SavedJobsDatabase.init();
    saved = await SavedJobsDatabase.getSavedJobs();
    loading = false;
    notifyListeners();
  }

  Future<void> toggleSaved(Job job) async {
    final exists = await SavedJobsDatabase.exists(job.id);
    if (exists) {
      await SavedJobsDatabase.deleteJob(job.id);
    } else {
      await SavedJobsDatabase.insertJob(job);
    }
    await loadSaved();
  }

  bool isSaved(int id) => saved.any((j) => j.id == id);
}
