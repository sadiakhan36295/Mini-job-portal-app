class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final int salary;
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
    return Job(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      company: json['company'] ?? json['brand'] ?? 'Company',
      location: json['location'] ?? 'Remote',
      salary: json['salary'] is int ? json['salary'] : (json['price'] ?? 0).toInt(),
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
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
}
