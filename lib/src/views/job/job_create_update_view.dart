import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:provider/provider.dart';

class JobCreateUpdateView extends StatefulWidget {
  final JobModel? job; // If null, it means we're creating a new job

  const JobCreateUpdateView({super.key, this.job});

  @override
  _JobCreateUpdateViewState createState() => _JobCreateUpdateViewState();
}

class _JobCreateUpdateViewState extends State<JobCreateUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final JobService _jobService = JobService();

  late TextEditingController _nameController;
  late TextEditingController _instructionsController;
  List<String> _selectedEquipmentIds = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.job?.name ?? '');
    _instructionsController = TextEditingController(text: widget.job?.instructions ?? '');
    _selectedEquipmentIds = widget.job?.equipmentIds ?? [];
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

        if (widget.job == null) {
          // Create new job
          await _jobService.addJob(JobModel(
             documentId: '', 
            name: name,
            instructions: instructions,
            equipmentIds: _selectedEquipmentIds,
          ));
        } else {
          // Update existing job
          await _jobService.updateJob(JobModel(
            documentId: widget.job!.documentId,
            name: name,
            instructions: instructions,
            equipmentIds: _selectedEquipmentIds,
          ));
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
    if (widget.job != null && widget.job!.documentId != null) {
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
        Navigator.of(context).pop(); // Close the form after deletion
      }
    }
  }

 Future<void> _addNewEquipment(BuildContext context, EquipmentService equipmentService) async {
    final _newEquipmentNameController = TextEditingController();
    final _newEquipmentDescriptionController = TextEditingController();
    final _newEquipmentPriceController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Equipment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _newEquipmentNameController,
              decoration: const InputDecoration(labelText: 'Equipment Name'),
            ),
            TextFormField(
              controller: _newEquipmentPriceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _newEquipmentDescriptionController,
              decoration: const InputDecoration(labelText: 'Equipment Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = _newEquipmentNameController.text;
              final description = _newEquipmentDescriptionController.text;
              if (name.isNotEmpty && description.isNotEmpty) {
                final newEquipment = EquipmentModel(
                  documentId: '', // Firebase will generate this automatically
                  name: name,
                  description: description, price: 0.0,
                );
                await equipmentService.addEquipment(newEquipment);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final equipmentService = Provider.of<EquipmentService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'Add Job' : 'Update Job'),
        actions: [
          if (widget.job != null) // Show delete button only for existing job
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
                decoration: const InputDecoration(labelText: 'Job Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(labelText: 'Instructions'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job instructions.';
                  }
                  return null;
                },
              ),
              StreamBuilder<List<EquipmentModel>>(
                stream: equipmentService.getEquipments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final equipmentList = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: null,
                        decoration: InputDecoration(labelText: 'Select Equipment'),
                        items: equipmentList.map((equipment) {
                          return DropdownMenuItem<String>(
                            value: equipment.documentId,
                            child: Text(equipment.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null && !_selectedEquipmentIds.contains(value)) {
                            setState(() {
                              _selectedEquipmentIds.add(value);
                            });
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _addNewEquipment(context, equipmentService),
                          child: const Text('Add New Equipment'),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Wrap(
                children: _selectedEquipmentIds.map((name) {
                  return Chip(
                    label: Text(name),
                    onDeleted: () {
                      setState(() {
                        _selectedEquipmentIds.remove(name);
                      });
                    },
                  );
                }).toList(),
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
