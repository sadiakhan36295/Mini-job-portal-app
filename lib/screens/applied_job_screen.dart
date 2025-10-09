import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/applied_provider.dart';
import '../widgets/job_card.dart';
import '../screens/job_detail_screen.dart';

class AppliedJobsScreen extends StatelessWidget {
  const AppliedJobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appliedProv = context.watch<AppliedProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Applied Jobs')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: appliedProv.loading
            ? const Center(child: CircularProgressIndicator())
            : appliedProv.applied.isEmpty
                ? const Center(child: Text('No applied jobs yet.'))
                : ListView.builder(
                    itemCount: appliedProv.applied.length,
                    itemBuilder: (ctx, i) {
                      final job = appliedProv.applied[i];
                      // Reuse JobCard but disable Apply action by design
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(job.title),
                          subtitle: Text('${job.company} • ${job.location}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await appliedProv.removeApplied(job.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Removed applied job')),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}