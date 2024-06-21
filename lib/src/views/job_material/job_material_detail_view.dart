import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_create_update_view.dart';

class JobMaterialDetailView extends StatelessWidget {
  final JobMaterialModel jobMaterial;

  const JobMaterialDetailView({super.key, required this.jobMaterial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobMaterial.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard('Name', jobMaterial.name),
            const SizedBox(height: 8.0),
            _buildCard('Price', '\$${jobMaterial.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8.0),
            _buildCard('Description', jobMaterial.description),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobMaterialCreateUpdateView(jobMaterial: jobMaterial),
                  ),
                );
              },
              child: const Text('Edit Material'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JobMaterialCreateUpdateView(),
                  ),
                );
              },
              child: const Text('Create New Material'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String content) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}
