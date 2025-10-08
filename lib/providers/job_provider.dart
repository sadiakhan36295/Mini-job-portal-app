import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/api_service.dart';

class JobProvider extends ChangeNotifier {
  List<Job> jobs = [];
  bool loading = false;
  String? error;

  Future<void> fetchJobs() async {
    loading = true;
    notifyListeners();
    try {
      jobs = await ApiService.fetchJobs();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
