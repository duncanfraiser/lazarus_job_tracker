import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/views/job/job_create_update_view.dart';

class JobDetailView extends StatelessWidget {
  final JobModel job;

  const JobDetailView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Instructions:', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8.0),
            Text(job.instructions),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobCreateUpdateView(job: job),
                  ),
                );
              },
              child: const Text('Edit Job'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobCreateUpdateView(),
                  ),
                );
              },
              child: const Text('Create New Job'),
            ),
          ],
        ),
      ),
    );
  }
}
