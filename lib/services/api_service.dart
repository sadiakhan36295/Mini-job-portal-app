import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job.dart';

class ApiService {
  // This uses the dummyjson example the task mentioned
  static Future<List<Job>> fetchJobs() async {
    final url = Uri.parse('https://dummyjson.com/products?limit=50');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final List products = data['products'] ?? [];
      return products.map((p) => Job.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
