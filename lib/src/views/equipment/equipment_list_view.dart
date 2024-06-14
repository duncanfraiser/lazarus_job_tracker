import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/views/equipment/create_update_view.dart';


class EquipmentListView extends StatefulWidget {
  @override
  _EquipmentListViewState createState() => _EquipmentListViewState();
}

class _EquipmentListViewState extends State<EquipmentListView> {
  final EquipmentService _equipmentService = EquipmentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateUpdateView()),
              ).then((value) => setState(() {})); // Refresh list after returning
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Equipment>>(
        future: _equipmentService.getAllEquipment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No equipment found'));
          } else {
            final equipmentList = snapshot.data!;
            return ListView.builder(
              itemCount: equipmentList.length,
              itemBuilder: (context, index) {
                final equipment = equipmentList[index];
                return ListTile(
                  title: Text(equipment.name),
                  subtitle: Text(equipment.description),
                  trailing: Text('\$${equipment.price.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateUpdateView(equipment: equipment),
                      ),
                    ).then((value) => setState(() {})); // Refresh list after returning
                  },
                  onLongPress: () async {
                    // Optionally, add a delete confirmation dialog
                    bool? confirmDelete = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Equipment'),
                        content: const Text('Are you sure you want to delete this equipment?'),
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
                      await _equipmentService.deleteEquipment(equipment.documentId!);
                      setState(() {});
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}