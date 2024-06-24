import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';
import 'package:lazarus_job_tracker/src/models/identifiable.dart'; // Add this import
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

  void _selectMultipleEquipments() async {
    final selectedEquipments = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return FutureBuilder<List<EquipmentModel>>(
          future: _equipmentService.getAllEquipment(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            var equipments = snapshot.data!;
            return MultiSelectDialog<EquipmentModel>(
              items: equipments,
              selectedValues: _selectedEquipmentIds,
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(item.name),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                );
              },
            );
          },
        );
      },
    );

    if (selectedEquipments != null) {
      setState(() {
        _selectedEquipmentIds = selectedEquipments;
      });
    }
  }

  void _selectMultipleMaterials() async {
    final selectedMaterials = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return FutureBuilder<List<JobMaterialModel>>(
          future: _jobMaterialService.getAllJobMaterials(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            var jobMaterials = snapshot.data!;
            return MultiSelectDialog<JobMaterialModel>(
              items: jobMaterials,
              selectedValues: _selectedJobMaterialIds,
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(item.name),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                );
              },
            );
          },
        );
      },
    );

    if (selectedMaterials != null) {
      setState(() {
        _selectedJobMaterialIds = selectedMaterials;
      });
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
                  if (!snapshot.hasData) return const CircularProgressIndicator();
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
              ElevatedButton(
                onPressed: _selectMultipleEquipments,
                child: Text('Select Equipments (${_selectedEquipmentIds.length})'),
              ),
              ElevatedButton(
                onPressed: _selectMultipleMaterials,
                child: Text('Select Materials (${_selectedJobMaterialIds.length})'),
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

class MultiSelectDialog<T extends Identifiable> extends StatefulWidget {
  final List<T> items;
  final List<String> selectedValues;
  final Widget Function(BuildContext context, T item, bool isSelected) itemBuilder;

  const MultiSelectDialog({super.key, 
    required this.items,
    required this.selectedValues,
    required this.itemBuilder,
  });

  @override
  _MultiSelectDialogState<T> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T extends Identifiable> extends State<MultiSelectDialog<T>> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                var item = widget.items[index];
                var isSelected = item.documentId != null && _selectedValues.contains(item.documentId!);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedValues.remove(item.documentId);
                      } else {
                        _selectedValues.add(item.documentId!);
                      }
                    });
                  },
                  child: widget.itemBuilder(context, item, isSelected),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(_selectedValues),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
