import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/material_model.dart';
import 'package:lazarus_job_tracker/src/views/material/material_create_update_view.dart';

class MaterialDetailView extends StatelessWidget {
  final MaterialModel material;

  const MaterialDetailView({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(material.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard('Name', material.name),
            const SizedBox(height: 8.0),
            _buildCard('Price', '\$${material.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8.0),
            _buildCard('Description', material.description),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaterialCreateUpdateView(material: material),
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
                    builder: (context) => const MaterialCreateUpdateView(),
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
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}
