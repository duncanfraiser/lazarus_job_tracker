import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:lazarus_job_tracker/src/views/job/job_detail_view.dart';
import 'package:lazarus_job_tracker/src/views/job/job_create_update_view.dart'; // Import the JobCreateUpdateView
import 'package:provider/provider.dart';

class JobListView extends StatelessWidget {
  const JobListView({super.key});

  @override
  Widget build(BuildContext context) {
    final jobService = Provider.of<JobService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobCreateUpdateView(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<JobModel>>(
        stream: jobService.getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jobs found'));
          }

          final jobs = snapshot.data!;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(job.name),
                  subtitle: Text(job.instructions),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailView(job: job),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
