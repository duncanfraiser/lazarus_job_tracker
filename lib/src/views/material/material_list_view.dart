import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/material_model.dart';
import 'package:lazarus_job_tracker/src/services/material_service.dart';
import 'package:lazarus_job_tracker/src/views/material/material_create_update_view.dart';

class MaterialListView extends StatefulWidget {
  const MaterialListView({super.key});

  @override
  _MaterialListViewState createState() => _MaterialListViewState();
}

class _MaterialListViewState extends State<MaterialListView> {
  final MaterialService _materialService = MaterialService();

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
                MaterialPageRoute(builder: (context) => const MaterialCreateUpdateView()),
              ).then((value) => setState(() {})); // Refresh list after returning
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MaterialModel>>(
        future: _materialService.getAllMaterial(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No material found'));
          } else {
            final materialList = snapshot.data!;
            return ListView.builder(
              itemCount: materialList.length,
              itemBuilder: (context, index) {
                final material = materialList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      material.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(material.description),
                    trailing: Text('\$${material.price.toStringAsFixed(2)}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaterialCreateUpdateView(material: material),
                        ),
                      ).then((value) => setState(() {})); // Refresh list after returning
                    },
                    onLongPress: () async {
                      // Optionally, add a delete confirmation dialog
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Material'),
                          content: const Text('Are you sure you want to delete this Material?'),
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
                        await _materialService.deleteMaterial(material.documentId!);
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
