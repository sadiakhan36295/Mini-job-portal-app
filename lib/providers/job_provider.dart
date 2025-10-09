import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../services/api_service.dart';

class JobProvider extends ChangeNotifier {
  List<Job> jobs = [];
  bool loading = false;
  String error = '';

  JobProvider() {
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    loading = true;
    notifyListeners();
    try {
      jobs = await ApiService.fetchJobs();
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  List<Job> search({String? q, String? category, int? minSalary}) {
    return jobs.where((job) {
      final matchesQ = q == null || q.isEmpty
          ? true
          : (job.title.toLowerCase().contains(q.toLowerCase()) ||
              job.company.toLowerCase().contains(q.toLowerCase()));
      final matchesCat = category == null || category == 'All' ? true : job.category == category;
      final matchesSalary = minSalary == null ? true : job.salary >= minSalary;
      return matchesQ && matchesCat && matchesSalary;
    }).toList();
  }
}