import 'dart:convert';

class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final double salary;
  final String description;
  final String category;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.description,
    required this.category,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    // Using dummyjson products -> mapping fields to a job
    return Job(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      company: json['brand'] ?? 'Unknown',
      location: json['category'] ?? 'Remote',
      salary: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'company': company,
        'location': location,
        'salary': salary,
        'description': description,
        'category': category,
      };

  String toJsonString() => jsonEncode(toJson());
  factory Job.fromJsonString(String s) => Job.fromJson(jsonDecode(s));
}
