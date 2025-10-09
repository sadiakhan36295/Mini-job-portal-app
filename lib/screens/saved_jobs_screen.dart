import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_provider.dart';
import '../widgets/job_card.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedProv = context.watch<SavedProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Jobs')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: savedProv.loading
            ? const Center(child: CircularProgressIndicator())
            : savedProv.saved.isEmpty
                ? const Center(child: Text('No saved jobs'))
                : ListView.builder(
                    itemCount: savedProv.saved.length,
                    itemBuilder: (_, i) => JobCard(job: savedProv.saved[i]),
                  ),
      ),
    );
  }
}