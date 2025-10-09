import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

class ApiService {
  // Example uses dummyjson products as mock data
  static Future<List<Job>> fetchJobs() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products?limit=30'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List items = data['products'] as List;
      return items.map((p) {
        return Job.fromJson({
          'id': p['id'],
          'title': p['title'],
          'company': p['brand'],
          'location': 'Remote',
          'salary': (p['price'] ?? 0).toInt(),
          'description': p['description'],
          'category': p['category'],
        });
      }).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}