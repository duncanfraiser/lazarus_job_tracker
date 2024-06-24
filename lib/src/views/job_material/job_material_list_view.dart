import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';
import 'package:lazarus_job_tracker/src/services/job_material_service.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_create_update_view.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_detail_view.dart';

class JobMaterialListView extends StatefulWidget {
  const JobMaterialListView({super.key});

  @override
  _JobMaterialListViewState createState() => _JobMaterialListViewState();
}

class _JobMaterialListViewState extends State<JobMaterialListView> {
  final JobMaterialService _jobMaterialService = JobMaterialService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JobMaterialCreateUpdateView()),
              ).then((value) => setState(() {})); // Refresh list after returning
            },
          ),
        ],
      ),
      body: StreamBuilder<List<JobMaterialModel>>(
        stream: _jobMaterialService.getJobMaterials(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No material found'));
          } else {
            final jobMaterialList = snapshot.data!;
            return ListView.builder(
              itemCount: jobMaterialList.length,
              itemBuilder: (context, index) {
                final jobMaterial = jobMaterialList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      jobMaterial.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(jobMaterial.description),
                    trailing: Text('\$${jobMaterial.price.toStringAsFixed(2)}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobMaterialDetailView(jobMaterial: jobMaterial),
                        ),
                      );
                    },
                    onLongPress: () async {
                      // Optionally, add a delete confirmation dialog
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Material'),
                          content: const Text('Are you sure you want to delete this material?'),
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
                        await _jobMaterialService.deleteJobMaterial(jobMaterial.documentId!);
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
