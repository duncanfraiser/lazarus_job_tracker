import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';

class EquipmentService {
  final CollectionReference _equipmentCollection = FirebaseFirestore.instance.collection('equipment');

  // Add Equipment
  Future<void> addEquipment(EquipmentModel equipment) async {
    try {
      await _equipmentCollection.add(equipment.toJson());
    } catch (e) {
      throw Exception('Error adding equipment: $e');
    }
  }

  // Get Equipment by ID
  Future<EquipmentModel?> getEquipmentById(String id) async {
    try {
      DocumentSnapshot doc = await _equipmentCollection.doc(id).get();
      if (doc.exists) {
        return EquipmentModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting equipment by ID: $e');
    }
  }

  // Get All Equipment
  Future<List<EquipmentModel>> getAllEquipment() async {
    try {
      QuerySnapshot querySnapshot = await _equipmentCollection.get();
      return querySnapshot.docs.map((doc) => EquipmentModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all equipment: $e');
    }
  }

    Stream<List<EquipmentModel>> getEquipments() {
    return _equipmentCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => EquipmentModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList()
    );
  }



  // Update Equipment
  Future<void> updateEquipment(EquipmentModel equipment) async {
    try {
      if (equipment.documentId != null) {
        await _equipmentCollection.doc(equipment.documentId).update(equipment.toJson());
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
      await _equipmentCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting equipment: $e');
    }
  }
}
