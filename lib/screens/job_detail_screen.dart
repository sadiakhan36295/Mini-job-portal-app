import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_model.dart';
import '../providers/saved_provider.dart';
import '../providers/applied_provider.dart';
import '../routes/app_routes.dart';

class JobDetailScreen extends StatelessWidget {
  static const routeName = '/job-detail';
  final Job job;
  const JobDetailScreen({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedProv = context.watch<SavedProvider>();
    final appliedProv = context.watch<AppliedProvider>();
    final isSaved = savedProv.isSaved(job.id);
    final isApplied = appliedProv.isApplied(job.id);

    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(job.company, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                  onPressed: () async {
                    await context.read<SavedProvider>().toggleSaved(job);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isSaved ? 'Removed from saved' : 'Saved to Saved Jobs')),
                    );
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: Icon(isApplied ? Icons.check_circle : Icons.send),
                  label: Text(isApplied ? 'Applied' : 'Apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isApplied ? Colors.grey : null,
                  ),
                  onPressed: isApplied
                      ? null
                      : () async {
                          await context.read<AppliedProvider>().addApplied(job);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Applied to ${job.title}'),
                              action: SnackBarAction(
                                label: 'View',
                                onPressed: () {
                                  Navigator.of(context).pushNamed(AppRoutes.applied);
                                },
                              ),
                            ),
                          );
                        },
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}