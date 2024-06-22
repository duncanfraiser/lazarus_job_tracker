import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
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
  late TextEditingController _clientIdController;
  late TextEditingController _equipmentIdsController;
  late TextEditingController _jobMaterialIdsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.job?.name ?? '');
    _instructionsController = TextEditingController(text: widget.job?.instructions ?? '');
    _clientIdController = TextEditingController(text: widget.job?.clientId ?? '');
    _equipmentIdsController = TextEditingController(text: widget.job?.equipmentIds.join(', ') ?? '');
    _jobMaterialIdsController = TextEditingController(text: widget.job?.jobMaterialIds.join(', ') ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _clientIdController.dispose();
    _equipmentIdsController.dispose();
    _jobMaterialIdsController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text;
        final instructions = _instructionsController.text;
        final clientId = _clientIdController.text;
        final equipmentIds = _equipmentIdsController.text.split(', ').toList();
        final jobMaterialIds = _jobMaterialIdsController.text.split(', ').toList();

        final job = JobModel(
          documentId: widget.job?.documentId,
          name: name,
          instructions: instructions,
          clientId: clientId,
          equipmentIds: equipmentIds,
          jobMaterialIds: jobMaterialIds,
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
              TextFormField(
                controller: _clientIdController,
                decoration: const InputDecoration(labelText: 'Client ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a client ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _equipmentIdsController,
                decoration: const InputDecoration(labelText: 'Equipment IDs (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter equipment IDs';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobMaterialIdsController,
                decoration: const InputDecoration(labelText: 'Material IDs (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter material IDs';
                  }
                  return null;
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
