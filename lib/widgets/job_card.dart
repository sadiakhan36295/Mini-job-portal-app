import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_model.dart';
import '../providers/saved_provider.dart';
import '../routes/app_routes.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedProv = context.watch<SavedProvider>();
    final isSaved = savedProv.isSaved(job.id);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.jobDetail, arguments: job),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                  IconButton(
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                    onPressed: () => context.read<SavedProvider>().toggleSaved(job),
                  )
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: Text('${job.company} • ${job.location}')),
                  Text('\$${job.salary}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // In a real app open apply URL or form
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Applied to ${job.title}')));
                  },
                  child: const Text('Apply'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
