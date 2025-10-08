import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_provider.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedProv = context.watch<SavedProvider>();
    if (savedProv.saved.isEmpty) {
      return Center(child: Text('No saved jobs yet.'));
    }
    return ListView.builder(
      itemCount: savedProv.saved.length,
      itemBuilder: (context, i) {
        final job = savedProv.saved[i];
        return JobCard(
          job: job,
          saved: true,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobDetailScreen(job: job))),
          onApply: () => _showApplied(context, job),
          onSave: () => savedProv.toggleSave(job),
        );
      },
    );
  }

  void _showApplied(BuildContext context, job) {
    showDialog(context: context, builder: (_) => AlertDialog(title: Text('Applied'), content: Text('Applied (demo).'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))]));
  }
}
