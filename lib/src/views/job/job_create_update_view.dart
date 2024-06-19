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
  final Map<String, EquipmentModel> _equipmentDetails = {}; 

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.job?.name ?? '');
    _instructionsController = TextEditingController(text: widget.job?.instructions ?? '');
    _selectedEquipmentIds = widget.job?.equipmentIds ?? [];
    _loadSelectedEquipmentDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _loadSelectedEquipmentDetails() async {
    if (_selectedEquipmentIds.isNotEmpty) {
      final equipmentService = Provider.of<EquipmentService>(context, listen: false);
      for (var id in _selectedEquipmentIds) {
        final equipment = await equipmentService.getEquipmentById(id);
        if (equipment != null) {
          setState(() {
            _equipmentDetails[id] = equipment;
          });
        }
      }
    }
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
    final newEquipmentNameController = TextEditingController();
    final newEquipmentDescriptionController = TextEditingController();
    final newEquipmentPriceController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Equipment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: newEquipmentNameController,
              decoration: const InputDecoration(labelText: 'Equipment Name'),
            ),
            TextFormField(
              controller: newEquipmentPriceController,
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
              controller: newEquipmentDescriptionController,
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
              final name = newEquipmentNameController.text;
              final description = newEquipmentDescriptionController.text;
              final price = double.tryParse(newEquipmentPriceController.text) ?? 0.0;
              if (name.isNotEmpty && description.isNotEmpty) {
                final newEquipment = EquipmentModel(
                  documentId: '', // Firebase will generate this automatically
                  name: name,
                  description: description, 
                  price: price,
                );
                final docRef = await equipmentService.addEquipment(newEquipment);
                setState(() {
                  _selectedEquipmentIds.add(docRef.id);
                  _equipmentDetails[docRef.id] = newEquipment;
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectEquipment(String id, EquipmentService equipmentService) async {
    final equipment = await equipmentService.getEquipmentById(id);
    if (equipment != null) {
      setState(() {
        _selectedEquipmentIds.add(id);
        _equipmentDetails[id] = equipment;
      });
    }
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
                            _selectEquipment(value, equipmentService);
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
              const SizedBox(height: 20),
              Text('Selected Equipment', style: Theme.of(context).textTheme.bodyLarge),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedEquipmentIds.length,
                itemBuilder: (context, index) {
                  final id = _selectedEquipmentIds[index];
                  final equipment = _equipmentDetails[id];
                  return ListTile(
                    title: Text(equipment?.name ?? 'Loading...'),
                    subtitle: Text('Price: \$${equipment?.price.toStringAsFixed(2) ?? 'Loading...'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _selectedEquipmentIds.remove(id);
                          _equipmentDetails.remove(id);
                        });
                      },
                    ),
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
