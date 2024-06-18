import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';

class CreateUpdateView extends StatefulWidget {
  final Equipment? equipment; // If null, it means we're creating a new equipment

  const CreateUpdateView({super.key, this.equipment});

  @override
  _CreateUpdateViewState createState() => _CreateUpdateViewState();
}

class _CreateUpdateViewState extends State<CreateUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final ClientService _equipmentService = ClientService();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment?.name ?? '');
    _priceController = TextEditingController(text: widget.equipment?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.equipment?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text;
        final price = double.parse(_priceController.text);
        final description = _descriptionController.text;

        if (widget.equipment == null) {
          // Create new equipment
          await _equipmentService.addEquipment(Equipment(
            name: name,
            price: price,
            description: description,
          ));
        } else {
          // Update existing equipment
          await _equipmentService.updateEquipment(Equipment(
            documentId: widget.equipment!.documentId,
            name: name,
            price: price,
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
                controller: _priceController,
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
