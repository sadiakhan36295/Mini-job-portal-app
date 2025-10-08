import 'package:flutter/material.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  final VoidCallback onApply;
  final VoidCallback onSave;
  final bool saved;

  const JobCard({
    Key? key,
    required this.job,
    required this.onTap,
    required this.onApply,
    required this.onSave,
    this.saved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: Text('${job.company} • ${job.location}')),
                  Text('\$${job.salary.toStringAsFixed(0)}'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                    onPressed: onSave,
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: onApply,
                    child: Text('Apply'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
