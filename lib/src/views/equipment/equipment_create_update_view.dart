import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';

class EquipmentCreateUpdateView extends StatefulWidget {
  final EquipmentModel? equipment; // If null, it means we're creating a new equipment

  const EquipmentCreateUpdateView({super.key, this.equipment});

  @override
  _EquipmentCreateUpdateViewState createState() => _EquipmentCreateUpdateViewState();
}

class _EquipmentCreateUpdateViewState extends State<EquipmentCreateUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final EquipmentService _equipmentService = EquipmentService();

  late TextEditingController _nameController;
  late TextEditingController _ratePerHourController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment?.name ?? '');
    _ratePerHourController = TextEditingController(text: widget.equipment?.ratePerHour.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.equipment?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ratePerHourController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text;
        final ratePerHour = double.parse(_ratePerHourController.text);
        final description = _descriptionController.text;

        if (widget.equipment == null) {
          // Create new equipment
          await _equipmentService.addEquipment(EquipmentModel(
            name: name,
            ratePerHour: ratePerHour,
            description: description,
          ));
        } else {
          // Update existing equipment
          await _equipmentService.updateEquipment(EquipmentModel(
            documentId: widget.equipment!.documentId,
            name: name,
            ratePerHour: ratePerHour,
            description: description,
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

  void _deleteEquipment() async {
    if (widget.equipment != null && widget.equipment!.documentId != null) {
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
        await _equipmentService.deleteEquipment(widget.equipment!.documentId!);
        Navigator.pop(context); // Close the form after deletion
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.equipment == null ? 'Create Equipment' : 'Update Equipment'),
        actions: [
          if (widget.equipment != null) // Show delete button only for existing equipment
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteEquipment,
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
                controller: _ratePerHourController,
                decoration: const InputDecoration(labelText: 'Rate per Hour'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rate per hour';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.equipment == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
