import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/models/material_model.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/services/material_service.dart';
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
  List<String> _selectedMaterialIds = [];
  final Map<String, MaterialModel> _materialDetails = {};
  String? _selectedClientId;
  ClientModel? _selectedClient;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.job?.name ?? '');
    _instructionsController = TextEditingController(text: widget.job?.instructions ?? '');
    _selectedEquipmentIds = widget.job?.equipmentIds ?? [];
    _selectedMaterialIds = widget.job?.materialIds ?? [];
    _selectedClientId = widget.job?.clientId;
    _loadSelectedClient();
    _loadSelectedEquipmentDetails();
    _loadSelectedMaterialDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _loadSelectedClient() async {
    if (_selectedClientId != null) {
      final clientService = Provider.of<ClientService>(context, listen: false);
      final client = await clientService.getClientById(_selectedClientId!);
      if (mounted) {
        setState(() {
          _selectedClient = client;
        });
      }
    }
  }

  Future<void> _loadSelectedEquipmentDetails() async {
    if (_selectedEquipmentIds.isNotEmpty) {
      final equipmentService = Provider.of<EquipmentService>(context, listen: false);
      for (var id in _selectedEquipmentIds) {
        final equipment = await equipmentService.getEquipmentById(id);
        if (mounted) {
          setState(() {
            if (equipment != null) {
              _equipmentDetails[id] = equipment;
            }
          });
        }
      }
    }
  }

  Future<void> _loadSelectedMaterialDetails() async {
    if (_selectedMaterialIds.isNotEmpty) {
      final materialService = Provider.of<MaterialService>(context, listen: false);
      for (var id in _selectedMaterialIds) {
        final material = await materialService.getMaterialById(id);
        if (mounted) {
          setState(() {
            if (material != null) {
              _materialDetails[id] = material;
            }
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
            materialIds: _selectedMaterialIds,
            clientId: _selectedClientId,
          ));
        } else {
          // Update existing job
          await _jobService.updateJob(JobModel(
            documentId: widget.job!.documentId,
            name: name,
            instructions: instructions,
            equipmentIds: _selectedEquipmentIds,
            materialIds: _selectedMaterialIds,
            clientId: _selectedClientId,
          ));
        }

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'),
          ));
        }
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
        await _jobService.deleteJob(widget.job!.documentId);
        if (mounted) {
          Navigator.of(context).pop(); // Close the form after deletion
        }
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
                if (mounted) {
                  setState(() {
                    _selectedEquipmentIds.add(docRef.id);
                    _equipmentDetails[docRef.id] = newEquipment;
                  });
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewMaterial(BuildContext context, MaterialService materialService) async {
    final newMaterialNameController = TextEditingController();
    final newMaterialDescriptionController = TextEditingController();
    final newMaterialPriceController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: newMaterialNameController,
              decoration: const InputDecoration(labelText: 'Material Name'),
            ),
            TextFormField(
              controller: newMaterialPriceController,
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
              controller: newMaterialDescriptionController,
              decoration: const InputDecoration(labelText: 'Material Description'),
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
              final name = newMaterialNameController.text;
              final description = newMaterialDescriptionController.text;
              final price = double.tryParse(newMaterialPriceController.text) ?? 0.0;
              if (name.isNotEmpty && description.isNotEmpty) {
                final newMaterial = MaterialModel(
                  documentId: '', // Firebase will generate this automatically
                  name: name,
                  description: description, 
                  price: price,
                );
                final docRef = await materialService.addMaterial(newMaterial);
                if (mounted) {
                  setState(() {
                    _selectedMaterialIds.add(docRef.id);
                    _materialDetails[docRef.id] = newMaterial;
                  });
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
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
    if (mounted) {
      setState(() {
        _selectedEquipmentIds.add(id);
        _equipmentDetails[id] = equipment!;
      });
    }
  }

  Future<void> _selectMaterial(String id, MaterialService materialService) async {
    final material = await materialService.getMaterialById(id);
    if (mounted) {
      setState(() {
        _selectedMaterialIds.add(id);
        _materialDetails[id] = material!;
      });
    }
  }

  Future<void> _selectClient(String id, ClientService clientService) async {
    final client = await clientService.getClientById(id);
    if (mounted) {
      setState(() {
        _selectedClientId = id;
        _selectedClient = client;
      });
    }
  }

  Future<void> _addNewClient(BuildContext context, ClientService clientService) async {
    final newClientFNameController = TextEditingController();
    final newClientLNameController = TextEditingController();
    final newClientAddressController = TextEditingController();
    final newClientPhoneController = TextEditingController();
    final newClientEmailController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Client'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: newClientFNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: newClientLNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: newClientAddressController,
              decoration: const InputDecoration(labelText: 'Billing Address'),
            ),
            TextFormField(
              controller: newClientPhoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: newClientEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
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
              final fName = newClientFNameController.text;
              final lName = newClientLNameController.text;
              final billingAddress = newClientAddressController.text;
              final phone = newClientPhoneController.text;
              final email = newClientEmailController.text;
              if (fName.isNotEmpty && lName.isNotEmpty && billingAddress.isNotEmpty && phone.isNotEmpty && email.isNotEmpty) {
                final newClient = ClientModel(
                  documentId: '', // Firebase will generate this automatically
                  fName: fName,
                  lName: lName,
                  billingAddress: billingAddress,
                  phone: phone,
                  email: email,
                );
                final docRef = await clientService.addClient(newClient);
                if (mounted) {
                  setState(() {
                    _selectedClientId = docRef.id;
                    _selectedClient = newClient;
                  });
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
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
    final clientService = Provider.of<ClientService>(context);
    final materialService = Provider.of<MaterialService>(context);

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
              StreamBuilder<List<ClientModel>>(
                stream: clientService.getClients(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final clientList = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedClientId,
                        decoration: const InputDecoration(labelText: 'Select Client'),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'addNewClient',
                            child: Text('Add New Client', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                          ...clientList.map((client) {
                            return DropdownMenuItem<String>(
                              value: client.documentId,
                              child: Row(
                                children: [
                                  if (_selectedClientId == client.documentId) 
                                    const Icon(Icons.check, color: Colors.green),
                                  Text('${client.fName} ${client.lName}'),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          if (value != null && value == 'addNewClient') {
                            _addNewClient(context, clientService);
                          } else if (value != null && value != _selectedClientId) {
                            _selectClient(value, clientService);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              StreamBuilder<List<EquipmentModel>>(
                stream: equipmentService.getEquipments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final equipmentList = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: null,
                        decoration: const InputDecoration(labelText: 'Select Equipment'),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'addNewEquipment',
                            child: Text('Add New Equipment', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                          ...equipmentList.map((equipment) {
                            return DropdownMenuItem<String>(
                              value: equipment.documentId,
                              child: Row(
                                children: [
                                  if (_selectedEquipmentIds.contains(equipment.documentId)) 
                                    const Icon(Icons.check, color: Colors.green),
                                  Text(equipment.name),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          if (value != null && value == 'addNewEquipment') {
                            _addNewEquipment(context, equipmentService);
                          } else if (value != null && !_selectedEquipmentIds.contains(value)) {
                            _selectEquipment(value, equipmentService);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              StreamBuilder<List<MaterialModel>>(
                stream: materialService.getMaterials(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final materialList = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: null,
                        decoration: const InputDecoration(labelText: 'Select Material'),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'addNewMaterial',
                            child: Text('Add New Material', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                          ...materialList.map((material) {
                            return DropdownMenuItem<String>(
                              value: material.documentId,
                              child: Row(
                                children: [
                                  if (_selectedMaterialIds.contains(material.documentId)) 
                                    const Icon(Icons.check, color: Colors.green),
                                  Text(material.name),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          if (value != null && value == 'addNewMaterial') {
                            _addNewMaterial(context, materialService);
                          } else if (value != null && !_selectedMaterialIds.contains(value)) {
                            _selectMaterial(value, materialService);
                          }
                        },
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
              Text('Selected Materials', style: Theme.of(context).textTheme.bodyLarge),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedMaterialIds.length,
                itemBuilder: (context, index) {
                  final id = _selectedMaterialIds[index];
                  final material = _materialDetails[id];
                  return ListTile(
                    title: Text(material?.name ?? 'Loading...'),
                    subtitle: Text('Price: \$${material?.price.toStringAsFixed(2) ?? 'Loading...'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _selectedMaterialIds.remove(id);
                          _materialDetails.remove(id);
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
