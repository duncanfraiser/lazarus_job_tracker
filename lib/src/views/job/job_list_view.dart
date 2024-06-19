import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:lazarus_job_tracker/src/views/job/job_create_update_view.dart';

class JobListView extends StatefulWidget {
  const JobListView({super.key});

  @override
  _JobListViewState createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  final JobService jobService = JobService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JobCreateUpdateView()),
              ).then((value) => setState(() {})); // Refresh list after returning
            },
          ),
        ],
      ),
      body: FutureBuilder<List<JobModel>>(
        future: jobService.getAllJob(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No job found'));
          } else {
            final jobList = snapshot.data!;
            return ListView.builder(
              itemCount: jobList.length,
              itemBuilder: (context, index) {
                final job = jobList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(job.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(job.instructions),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobCreateUpdateView(job: job),
                        ),
                      ).then((value) => setState(() {})); // Refresh list after returning
                    },
                    onLongPress: () async {
                      // Optionally, add a delete confirmation dialog
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Job'),
                          content: const Text('Are you sure you want to delete this job?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        await jobService.deleteJob(job.documentId);
                        setState(() {});
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
