import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/services/job_material_service.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/views/client/client_detail_view.dart'; // Ensure this is the only import
// import 'package:lazarus_job_tracker/src/views/client/client_list_view.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_usage_dialog.dart';
import 'package:lazarus_job_tracker/src/views/job/job_create_update_view.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_usage_dialog.dart';

class JobDetailView extends StatefulWidget {
  final JobModel job;

  const JobDetailView({super.key, required this.job});

  @override
  _JobDetailViewState createState() => _JobDetailViewState();
}

class _JobDetailViewState extends State<JobDetailView> {
  @override
  Widget build(BuildContext context) {
    final equipmentService = Provider.of<EquipmentService>(context, listen: false);
    final materialService = Provider.of<JobMaterialService>(context, listen: false);
    final clientService = Provider.of<ClientService>(context, listen: false);
    final jobService = Provider.of<JobService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Instructions:', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8.0),
            Text(widget.job.instructions),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiProvider(
                      providers: [
                        Provider<JobService>(create: (_) => jobService),
                        Provider<ClientService>(create: (_) => clientService),
                        Provider<EquipmentService>(create: (_) => equipmentService),
                        Provider<JobMaterialService>(create: (_) => materialService),
                      ],
                      child: JobCreateUpdateView(job: widget.job),
                    ),
                  ),
                );
              },
              child: const Text('Edit Job'),
            ),
            const SizedBox(height: 16.0),
            Text('Client', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8.0),
            FutureBuilder<ClientModel?>(
              future: _loadClientDetails(clientService, widget.job.clientId),
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
              future: _loadEquipmentDetails(equipmentService, widget.job.equipmentIds),
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
                    final usage = widget.job.equipmentUsage[equipment.documentId] ?? [];
                    final totalHours = usage.fold<double>(0, (sum, item) => sum + item.hours);
                    final totalCost = totalHours * equipment.ratePerHour;

                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(equipment.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rate per Hour: \$${equipment.ratePerHour.toStringAsFixed(2)}'),
                            Text('Total Hours: ${totalHours.toStringAsFixed(2)}'),
                            Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
                          ],
                        ),
                        onTap: () async {
                          final result = await showDialog<List<EquipmentUsage>>(
                            context: context,
                            builder: (context) => EquipmentUsageDialog(
                              equipment: equipment,
                              usage: usage,
                            ),
                          );

                          if (result != null) {
                            // Update the job's equipment usage and save it to the database
                            setState(() {
                              if (equipment.documentId != null) {
                                widget.job.equipmentUsage[equipment.documentId!] = result;
                              }
                            });
                            await jobService.updateJob(widget.job); // Save job to Firestore
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
            FutureBuilder<List<JobMaterialModel>>(
              future: _loadMaterialDetails(materialService, widget.job.jobMaterialIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No materials found');
                }

                final jobMaterialList = snapshot.data!;
                return Column(
                  children: jobMaterialList.map((jobMaterial) {
                    final usage = widget.job.jobMaterialUsage[jobMaterial.documentId] ?? [];
                    final totalQuantity = usage.fold<double>(0, (sum, item) => sum + item.quantity);
                    final totalCost = totalQuantity * jobMaterial.price;

                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(jobMaterial.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: \$${jobMaterial.price.toStringAsFixed(2)}'),
                            Text('Total Quantity: ${totalQuantity.toStringAsFixed(2)}'),
                            Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
                          ],
                        ),
                        onTap: () async {
                          final result = await showDialog<List<JobMaterialUsage>>(
                            context: context,
                            builder: (context) => JobMaterialUsageDialog(
                              jobMaterialName: jobMaterial.name,
                              usage: usage,
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              if (jobMaterial.documentId != null) {
                                widget.job.jobMaterialUsage[jobMaterial.documentId!] = result;
                              }
                            });
                            await jobService.updateJob(widget.job); // Save job to Firestore
                          }
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

  Future<List<JobMaterialModel>> _loadMaterialDetails(JobMaterialService service, List<String> ids) async {
    return Future.wait(ids.map((id) async => await service.getJobMaterialById(id) ?? JobMaterialModel(
      documentId: id,
      name: 'Unknown',
      description: 'No description available',
      price: 0.0,
    )).toList());
  }
}
