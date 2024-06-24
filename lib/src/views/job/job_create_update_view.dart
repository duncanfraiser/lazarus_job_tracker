import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/services/job_material_service.dart';

class JobCreateUpdateView extends StatefulWidget {
  final JobModel? job; // If null, it means we're creating a new job

  const JobCreateUpdateView({super.key, this.job});

  @override
  _JobCreateUpdateViewState createState() => _JobCreateUpdateViewState();
}

class _JobCreateUpdateViewState extends State<JobCreateUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final JobService _jobService = JobService();
  final ClientService _clientService = ClientService();
  final EquipmentService _equipmentService = EquipmentService();
  final JobMaterialService _jobMaterialService = JobMaterialService();

  late TextEditingController _nameController;
  late TextEditingController _instructionsController;
  String? _selectedClientId;
  List<String> _selectedEquipmentIds = [];
  List<String> _selectedJobMaterialIds = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.job?.name ?? '');
    _instructionsController = TextEditingController(text: widget.job?.instructions ?? '');
    _selectedClientId = widget.job?.clientId;
    _selectedEquipmentIds = widget.job?.equipmentIds ?? [];
    _selectedJobMaterialIds = widget.job?.jobMaterialIds ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text;
        final instructions = _instructionsController.text;
        final clientId = _selectedClientId;

        final job = JobModel(
          documentId: widget.job?.documentId,
          name: name,
          instructions: instructions,
          clientId: clientId!,
          equipmentIds: _selectedEquipmentIds,
          jobMaterialIds: _selectedJobMaterialIds,
          equipmentUsage: widget.job?.equipmentUsage ?? {},
          jobMaterialUsage: widget.job?.jobMaterialUsage ?? {},
        );

        if (widget.job == null) {
          await _jobService.addJob(job);
        } else {
          await _jobService.updateJob(job);
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      }
    }
  }

  void _deleteJob() async {
    if (widget.job != null) {
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
        await _jobService.deleteJob(widget.job!.documentId!);
        Navigator.pop(context); // Close the form after deletion
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'Create Job' : 'Update Job'),
        actions: [
          if (widget.job != null) // Show delete button only for existing jobs
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteJob,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(labelText: 'Instructions'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter instructions';
                  }
                  return null;
                },
              ),
              StreamBuilder<List<ClientModel>>(
                stream: _clientService.getClients(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  var clients = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _selectedClientId,
                    decoration: const InputDecoration(labelText: 'Client'),
                    items: clients.map((client) {
                      return DropdownMenuItem<String>(
                        value: client.documentId,
                        child: Text(client.name), // Using name property for display
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClientId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a client';
                      }
                      return null;
                    },
                  );
                },
              ),
              StreamBuilder<List<EquipmentModel>>(
                stream: _equipmentService.getEquipments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  var equipments = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _selectedEquipmentIds.isNotEmpty ? _selectedEquipmentIds.first : null,
                    decoration: const InputDecoration(labelText: 'Equipment'),
                    items: equipments.map((equipment) {
                      return DropdownMenuItem<String>(
                        value: equipment.documentId,
                        child: Text(equipment.name), // Using name property for display
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEquipmentIds = value != null ? [value] : [];
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select equipment';
                      }
                      return null;
                    },
                  );
                },
              ),
              StreamBuilder<List<JobMaterialModel>>(
                stream: _jobMaterialService.getJobMaterials(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  var jobMaterials = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _selectedJobMaterialIds.isNotEmpty ? _selectedJobMaterialIds.first : null,
                    decoration: const InputDecoration(labelText: 'Material'),
                    items: jobMaterials.map((jobMaterial) {
                      return DropdownMenuItem<String>(
                        value: jobMaterial.documentId,
                        child: Text(jobMaterial.name), // Using name property for display
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedJobMaterialIds = value != null ? [value] : [];
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select material';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.job == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
