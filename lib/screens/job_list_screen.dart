import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';
import '../providers/saved_provider.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';
import 'saved_jobs_screen.dart';
import 'profile_screen.dart';

class JobListScreen extends StatefulWidget {
  static const routeName = '/home';
  const JobListScreen({Key? key}) : super(key: key);

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final jobProvider = context.read<JobProvider>();
    final savedProvider = context.read<SavedProvider>();
    jobProvider.fetchJobs();
    savedProvider.loadSaved();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _body() {
    switch (_selectedIndex) {
      case 0:
        return Consumer2<JobProvider, SavedProvider>(
          builder: (context, jobProv, savedProv, _) {
            if (jobProv.loading) return Center(child: CircularProgressIndicator());
            if (jobProv.error != null) return Center(child: Text('Error: ${jobProv.error}'));
            return RefreshIndicator(
              onRefresh: jobProv.fetchJobs,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: jobProv.jobs.length,
                itemBuilder: (context, i) {
                  final job = jobProv.jobs[i];
                  final saved = savedProv.isSaved(job.id);
                  return JobCard(
                    job: job,
                    saved: saved,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobDetailScreen(job: job))),
                    onApply: () => _showAppliedDialog(job),
                    onSave: () => savedProv.toggleSave(job),
                  );
                },
              ),
            );
          },
        );
      case 1:
        return SavedJobsScreen();
      case 2:
        return ProfileScreen();
      default:
        return Center(child: Text('More'));
    }
  }

  void _showAppliedDialog(job) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Applied'),
        content: Text('You applied to "${job.title}" at ${job.company}. (Demo)'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Job Portal'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: open search modal (I can add it if you want)
              showSearch(context: context, delegate: SimpleJobSearch());
            },
          )
        ],
      ),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}

// Simple search delegate (demo)
class SimpleJobSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, ''), icon: Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    final jobs = context.read<JobProvider>().jobs.where((j) => j.title.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(
      children: jobs.map((job) => ListTile(title: Text(job.title), subtitle: Text(job.company), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(job: job))))).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = context.read<JobProvider>().jobs.where((j) => j.title.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(
      children: suggestions.map((job) => ListTile(title: Text(job.title), onTap: () => query = job.title)).toList(),
    );
  }
}
