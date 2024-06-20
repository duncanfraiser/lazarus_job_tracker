import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/models/material_model.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/services/material_service.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_usage_dialog.dart';
import 'package:lazarus_job_tracker/src/views/job/job_create_update_view.dart';
import 'package:lazarus_job_tracker/src/views/material/material_detail_view.dart';
import 'package:lazarus_job_tracker/src/views/client/client_detail_view.dart';
import 'package:provider/provider.dart';

class JobDetailView extends StatelessWidget {
  final JobModel job;

  const JobDetailView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final equipmentService = Provider.of<EquipmentService>(context, listen: false);
    final materialService = Provider.of<MaterialService>(context, listen: false);
    final clientService = Provider.of<ClientService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(job.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
            const SizedBox(height: 16.0),
            Text('Client', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8.0),
            FutureBuilder<ClientModel?>(
              future: _loadClientDetails(clientService, job.clientId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No client found');
                }

                final client = snapshot.data!;
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text('${client.fName} ${client.lName}'),
                    subtitle: Text('Address: ${client.billingAddress}\nPhone: ${client.phone}\nEmail: ${client.email}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientDetailView(client: client),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            Text('Equipment', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8.0),
            FutureBuilder<List<EquipmentModel>>(
              future: _loadEquipmentDetails(equipmentService, job.equipmentIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No equipment found');
                }

                final equipmentList = snapshot.data!;
                return Column(
                  children: equipmentList.map((equipment) {
                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(equipment.name),
                        subtitle: Text('Rate per Hour: \$${equipment.ratePerHour.toStringAsFixed(2)}'),
                        onTap: () async {
                          final usage = job.equipmentUsage[equipment.documentId!] ?? [];
                          final result = await showDialog<List<EquipmentUsage>>(
                            context: context,
                            builder: (context) => EquipmentUsageDialog(
                              equipment: equipment,
                              usage: usage,
                            ),
                          );

                          if (result != null) {
                            // Update the job's equipment usage and save it to the database
                            job.equipmentUsage[equipment.documentId!] = result;
                            // Save job to Firestore here
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16.0),
            Text('Materials', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8.0),
            FutureBuilder<List<MaterialModel>>(
              future: _loadMaterialDetails(materialService, job.materialIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No materials found');
                }

                final materialList = snapshot.data!;
                return Column(
                  children: materialList.map((material) {
                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(material.name),
                        subtitle: Text('Price: \$${material.price.toStringAsFixed(2)}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaterialDetailView(material: material),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<ClientModel?> _loadClientDetails(ClientService service, String? id) async {
    if (id == null) return null;
    return await service.getClientById(id);
  }

  Future<List<EquipmentModel>> _loadEquipmentDetails(EquipmentService service, List<String> ids) async {
    return Future.wait(ids.map((id) async => await service.getEquipmentById(id) ?? EquipmentModel(
      documentId: id,
      name: 'Unknown',
      description: 'No description available',
      ratePerHour: 0.0,
    )).toList());
  }

  Future<List<MaterialModel>> _loadMaterialDetails(MaterialService service, List<String> ids) async {
    return Future.wait(ids.map((id) async => await service.getMaterialById(id) ?? MaterialModel(
      documentId: id,
      name: 'Unknown',
      description: 'No description available',
      price: 0.0,
    )).toList());
  }
}
