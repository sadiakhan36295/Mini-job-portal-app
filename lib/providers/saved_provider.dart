import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/db_service.dart';

class SavedProvider extends ChangeNotifier {
  List<Job> saved = [];

  Future<void> loadSaved() async {
    saved = await SavedJobsDatabase.getSavedJobs();
    notifyListeners();
  }

  bool isSaved(int id) => saved.any((j) => j.id == id);

  Future<void> toggleSave(Job job) async {
    if (isSaved(job.id)) {
      await SavedJobsDatabase.removeJob(job.id);
    } else {
      await SavedJobsDatabase.saveJob(job);
    }
    await loadSaved();
  }
}
