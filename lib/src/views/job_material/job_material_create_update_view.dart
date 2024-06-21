import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';
import 'package:lazarus_job_tracker/src/services/Job_material_service.dart';

class JobMaterialCreateUpdateView extends StatefulWidget {
  final JobMaterialModel? jobMaterial; // If null, it means we're creating a new Material

  const JobMaterialCreateUpdateView({super.key, this.jobMaterial});

  @override
  _JobMaterialCreateUpdateViewState createState() => _JobMaterialCreateUpdateViewState();
}

class _JobMaterialCreateUpdateViewState extends State<JobMaterialCreateUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final JobMaterialService _materialService = JobMaterialService();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.jobMaterial?.name ?? '');
    _priceController = TextEditingController(text: widget.jobMaterial?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.jobMaterial?.description ?? '');
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

        if (widget.jobMaterial == null) {
          // Create new Material
          await _materialService.addJobMaterial(JobMaterialModel(
            name: name,
            price: price,
            description: description,
          ));
        } else {
          // Update existing Material
          await _materialService.updateJobMaterial(JobMaterialModel(
            documentId: widget.jobMaterial!.documentId,
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

  void _deleteMaterial() async {
    if (widget.jobMaterial != null && widget.jobMaterial!.documentId != null) {
      bool? confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Material'),
          content: const Text('Are you sure you want to delete this Material?'),
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
        await _materialService.deleteJobMaterial(widget.jobMaterial!.documentId!);
        Navigator.pop(context); // Close the form after deletion
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobMaterial == null ? 'Create Material' : 'Update Material'),
        actions: [
          if (widget.jobMaterial != null) // Show delete button only for existing Material
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteMaterial,
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
                child: Text(widget.jobMaterial == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
