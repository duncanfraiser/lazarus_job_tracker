import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_create_update_view.dart';

class EquipmentDetailView extends StatelessWidget {
  final EquipmentModel equipment;

  const EquipmentDetailView({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipment.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Equipment Details', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: const Text('Name'),
                subtitle: Text(equipment.name),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: const Text('Description'),
                subtitle: Text(equipment.description),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: const Text('Rate per Hour'),
                subtitle: Text('\$${equipment.ratePerHour.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EquipmentCreateUpdateView(equipment: equipment),
                  ),
                );
              },
              child: const Text('Edit Equipment'),
            ),
          ],
        ),
      ),
    );
  }
}

