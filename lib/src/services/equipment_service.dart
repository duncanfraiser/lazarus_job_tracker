import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';

class EquipmentService {
  final CollectionReference equipmentCollection = FirebaseFirestore.instance.collection('equipment');

  // Add Equipment
  Future<DocumentReference> addEquipment(EquipmentModel equipment) async {
    try {
      return await equipmentCollection.add(equipment.toJson());
    } catch (e) {
      throw Exception('Error adding equipment: $e');
    }
  }

  // Get Equipment by ID
  Future<EquipmentModel?> getEquipmentById(String id) async {
    try {
      DocumentSnapshot doc = await equipmentCollection.doc(id).get();
      if (doc.exists) {
        return EquipmentModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting equipment by ID: $e');
    }
  }

  // Get All Equipment as a Stream
  Stream<List<EquipmentModel>> getEquipments() {
    return equipmentCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => EquipmentModel.fromDocument(doc)).toList()
    );
  }

  // Get All Equipment as a Future
  Future<List<EquipmentModel>> getAllEquipment() async {
    try {
      QuerySnapshot querySnapshot = await equipmentCollection.get();
      return querySnapshot.docs.map((doc) => EquipmentModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all equipment: $e');
    }
  }

  // Update Equipment
  Future<void> updateEquipment(EquipmentModel equipment) async {
    try {
      if (equipment.documentId != null) {
        await equipmentCollection.doc(equipment.documentId).update(equipment.toJson());
      } else {
        throw Exception('Error updating equipment: Document ID is null');
      }
    } catch (e) {
      throw Exception('Error updating equipment: $e');
    }
  }

  // Delete Equipment
  Future<void> deleteEquipment(String id) async {
    try {
      await equipmentCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting equipment: $e');
    }
  }
}
