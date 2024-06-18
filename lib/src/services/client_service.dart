import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';

class ClientService {
  final CollectionReference _clientCollection = FirebaseFirestore.instance.collection('client');

  // Add Client
  Future<void> addClient(Client client) async {
    try {
      await _clientCollection.add(client.toJson());
    } catch (e) {
      throw Exception('Error adding client: $e');
    }
  }

  // Get Client by ID
  Future<Client?> getClientById(String id) async {
    try {
      DocumentSnapshot doc = await _clientCollection.doc(id).get();
      if (doc.exists) {
        return Client.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting client by ID: $e');
    }
  }

  // Get All Client
  Future<List<Client>> getAllClient() async {
    try {
      QuerySnapshot querySnapshot = await _clientCollection.get();
      return querySnapshot.docs.map((doc) => Client.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all Client: $e');
    }
  }

  // Update Client
  Future<void> updateClient(Client client) async {
    try {
      if (client.documentId != null) {
        await _clientCollection.doc(client.documentId).update(client.toJson());
      } else {
        throw Exception('Error updating client: Document ID is null');
      }
    } catch (e) {
      throw Exception('Error updating client: $e');
    }
  }

  // Delete Equipment
  Future<void> deleteClient(String id) async {
    try {
      await _clientCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting client: $e');
    }
  }
}
