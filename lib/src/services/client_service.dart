import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';

class ClientService {
  final CollectionReference clientCollection = FirebaseFirestore.instance.collection('client');

  // Add Client  
  Future<DocumentReference> addClient(ClientModel client) async {
    try {
      return await clientCollection.add(client.toJson());
    } catch (e) {
      throw Exception('Error adding client: $e');
    }
  }


  // Get Client by ID
  Future<ClientModel?> getClientById(String id) async {
    try {
      DocumentSnapshot doc = await clientCollection.doc(id).get();
      if (doc.exists) {
        return ClientModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting client by ID: $e');
    }
  }

  // Get All Clients as a Stream
  Stream<List<ClientModel>> getClients() {
    return clientCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => ClientModel.fromDocument(doc)).toList()
    );
  }

  // Get All Clients as a Future
  Future<List<ClientModel>> getAllClients() async {
    try {
      QuerySnapshot querySnapshot = await clientCollection.get();
      return querySnapshot.docs.map((doc) => ClientModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all clients: $e');
    }
  }

  // Update Client
  Future<void> updateClient(ClientModel client) async {
    try {
      if (client.documentId != null) {
        await clientCollection.doc(client.documentId).update(client.toJson());
      } else {
        throw Exception('Error updating client: Document ID is null');
      }
    } catch (e) {
      throw Exception('Error updating client: $e');
    }
  }

  // Delete Client
  Future<void> deleteClient(String id) async {
    try {
      await clientCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting client: $e');
    }
  }
}
