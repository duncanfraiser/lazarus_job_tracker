import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/material_model.dart';

class MaterialService {
  final CollectionReference _materialCollection = FirebaseFirestore.instance.collection('material');

  // Add Material
  Future<void> addMaterial(MaterialModel material) async {
    try {
      await _materialCollection.add(material.toJson());
    } catch (e) {
      throw Exception('Error adding material: $e');
    }
  }

  // Get Material by ID
  Future<MaterialModel?> getMaterialById(String id) async {
    try {
      DocumentSnapshot doc = await _materialCollection.doc(id).get();
      if (doc.exists) {
        return MaterialModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting material by ID: $e');
    }
  }

  // Get All Material
  Future<List<MaterialModel>> getAllMaterial() async {
    try {
      QuerySnapshot querySnapshot = await _materialCollection.get();
      return querySnapshot.docs.map((doc) => MaterialModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all Material: $e');
    }
  }

  // Update Material
  Future<void> updateMaterial(MaterialModel material) async {
    try {
      if (material.documentId != null) {
        await _materialCollection.doc(material.documentId).update(material.toJson());
      } else {
        throw Exception('Error updating Material: Document ID is null');
      }
    } catch (e) {
      throw Exception('Error updating Material: $e');
    }
  }

  // Delete Material
  Future<void> deleteMaterial(String id) async {
    try {
      await _materialCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting Material: $e');
    }
  }
}
