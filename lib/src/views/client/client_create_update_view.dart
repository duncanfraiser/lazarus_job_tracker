import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';

class ClientCreateUpdateView extends StatefulWidget {
  final ClientModel? client; // If null, it means we're creating a new client

  const ClientCreateUpdateView({super.key, this.client});

  @override
  _ClientCreateUpdateViewState createState() => _ClientCreateUpdateViewState();
}

class _ClientCreateUpdateViewState extends State<ClientCreateUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final ClientService _clientService = ClientService();

  late TextEditingController _fNameController;
  late TextEditingController _lNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _fNameController = TextEditingController(text: widget.client?.fName ?? '');
    _lNameController = TextEditingController(text: widget.client?.lName ?? '');
    _addressController = TextEditingController(text: widget.client?.billingAddress ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final fName = _fNameController.text;
        final lName = _lNameController.text;
        final address = _addressController.text;
        final phone = _phoneController.text;
        final email = _emailController.text;

        if (widget.client == null) {
          // Create new client
          await _clientService.addClient(ClientModel(
            fName: fName,
            lName: lName,
            billingAddress: address,
            phone: phone,
            email: email,
          ));
        } else {
          // Update existing client
          await _clientService.updateClient(ClientModel(
            documentId: widget.client!.documentId,
            fName: fName,
            lName: lName,
            billingAddress: address,
            phone: phone,
            email: email,
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

  void _deleteClient() async {
    if (widget.client != null && widget.client!.documentId != null) {
      bool? confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Client'),
          content: const Text('Are you sure you want to delete this client?'),
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
        await _clientService.deleteClient(widget.client!.documentId!);
        Navigator.pop(context); // Close the form after deletion
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null ? 'Create Client' : 'Update Client'),
        actions: [
          if (widget.client != null) // Show delete button only for existing client
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteClient,
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
                controller: _fNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Billing Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.client == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
