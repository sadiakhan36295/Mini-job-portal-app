import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job.dart';
import '../providers/saved_provider.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;
  const JobDetailScreen({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedProv = context.watch<SavedProvider>();
    final isSaved = savedProv.isSaved(job.id);
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(job.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('${job.company} • ${job.location}'),
          SizedBox(height: 8),
          Text('Salary: \$${job.salary.toStringAsFixed(0)}'),
          SizedBox(height: 12),
          Text('Category: ${job.category}'),
          SizedBox(height: 16),
          Expanded(child: SingleChildScrollView(child: Text(job.description))),
          Row(
            children: [
              IconButton(
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () => savedProv.toggleSave(job),
              ),
              Spacer(),
              ElevatedButton(onPressed: () => _apply(context), child: Text('Apply')),
            ],
          )
        ]),
      ),
    );
  }

  void _apply(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Apply'),
        content: Text('Applied to ${job.title} (demo).'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }
}
