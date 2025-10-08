import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';
import '../providers/saved_provider.dart';
import '../widgets/job_card.dart';
import '../routes/app_routes.dart';
import '../models/job_model.dart';

class JobListScreen extends StatefulWidget {
  static const routeName = '/';
  const JobListScreen({Key? key}) : super(key: key);

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  int _currentIndex = 0;
  String searchQ = '';
  String selectedCategory = 'All';
  int? minSalary;

  void _openSearchModal(JobProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final qCtrl = TextEditingController(text: searchQ);
        final salaryCtrl = TextEditingController(text: minSalary?.toString() ?? '');
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [const Text('Search Jobs', style: TextStyle(fontWeight: FontWeight.bold)), const Spacer(), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx))]),
              TextField(controller: qCtrl, decoration: const InputDecoration(labelText: 'Title or Company')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: <String>['All', 'smartphones', 'laptops', 'home', 'groceries', 'fragrances'].map((c) => DropdownMenuItem(child: Text(c), value: c)).toList(),
                onChanged: (v) => selectedCategory = v ?? 'All',
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 8),
              TextField(controller: salaryCtrl, decoration: const InputDecoration(labelText: 'Min Salary'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    searchQ = qCtrl.text;
                    minSalary = salaryCtrl.text.isEmpty ? null : int.tryParse(salaryCtrl.text);
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Search'),
              )
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobProv = context.watch<JobProvider>();
    final savedProv = context.watch<SavedProvider>();

    final filtered = jobProv.search(q: searchQ, category: selectedCategory, minSalary: minSalary);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job List Page'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => _openSearchModal(jobProv))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await context.read<JobProvider>().fetchJobs(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: jobProv.loading
              ? const Center(child: CircularProgressIndicator())
              : jobProv.error.isNotEmpty
                  ? Center(child: Text('Error: ${jobProv.error}'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => JobCard(job: filtered[i]),
                    ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: _currentIndex,
  selectedItemColor: const Color(0xFF0D47A1), // Blue for selected
  unselectedItemColor: Colors.black, // Black for others
  onTap: (i) {
    setState(() => _currentIndex = i);
    switch (i) {
      case 0:
        // already on home
        break;
      case 1:
        Navigator.of(context).pushNamed(AppRoutes.saved);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoutes.profile);
        break;
      case 3:
        Navigator.of(context).pushNamed(AppRoutes.settings);
        break;
    }
  },
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Saved'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ],
),

    );
  }
}
