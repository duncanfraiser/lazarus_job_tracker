import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/views/client/client_create_update_view.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:provider/provider.dart';

class ClientDetailView extends StatelessWidget {
  final ClientModel client;

  const ClientDetailView({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final clientService = Provider.of<ClientService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('${client.fName} ${client.lName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientCreateUpdateView(client: client),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmDelete = await showDialog<bool>(
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
                await clientService.deleteClient(client.documentId!);
                Navigator.pop(context); // Close the detail view after deletion
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Client Details', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: const Text('First Name'),
                subtitle: Text(client.fName),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: const Text('Last Name'),
                subtitle: Text(client.lName),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: const Text('Billing Address'),
                subtitle: Text(client.billingAddress),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: const Text('Phone'),
                subtitle: Text(client.phone),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: const Text('Email'),
                subtitle: Text(client.email),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientCreateUpdateView(client: client),
                  ),
                );
              },
              child: const Text('Edit Client'),
            ),
          ],
        ),
      ),
    );
  }
}
