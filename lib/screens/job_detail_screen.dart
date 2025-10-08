import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_model.dart';
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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // Make entire content scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job.company,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 6),
              Text('${job.location} • \$${job.salary}'),
              const SizedBox(height: 12),
              Text('Category: ${job.category}'),
              const SizedBox(height: 12),
              Text(job.description),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                    label: Text(isSaved ? 'Saved' : 'Save'),
                    onPressed: () => context.read<SavedProvider>().toggleSaved(job),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Applied to ${job.title}'))),
                    child: const Text('Apply'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
