import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/views/client/client_create_update_view.dart';

class ClientListView extends StatefulWidget {
  const ClientListView({super.key});

  @override
  _ClientListViewState createState() => _ClientListViewState();
}

class _ClientListViewState extends State<ClientListView> {
  final ClientService _clientService = ClientService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientCreateUpdateView()),
              ).then((value) => setState(() {})); // Refresh list after returning
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ClientModel>>(
        future: _clientService.getAllClient(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No client found'));
          } else {
            final clientList = snapshot.data!;
            return ListView.builder(
              itemCount: clientList.length,
              itemBuilder: (context, index) {
                final client = clientList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      '${client.fName} ${client.lName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Address: ${client.billingAddress}\nEmail: ${client.email}'),
                    trailing: InkWell(
                      child: Text(
                        client.phone,
                        style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        // Optionally, handle phone number tap, e.g., call or SMS
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientCreateUpdateView(client: client),
                        ),
                      ).then((value) => setState(() {})); // Refresh list after returning
                    },
                    onLongPress: () async {
                      // Optionally, add a delete confirmation dialog
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
                        await _clientService.deleteClient(client.documentId!);
                        setState(() {});
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
