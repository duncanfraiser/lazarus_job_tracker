import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/material_model.dart';


class MaterialService {
  final CollectionReference _materialsCollection =
      FirebaseFirestore.instance.collection('materials');

  // Create
  Future<void> addMaterial(MaterialModel material) {
    return _materialsCollection.add(material.toMap());
  }

  // Read
  Stream<List<MaterialModel>> getMaterials() {
    return _materialsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MaterialModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Update
  Future<void> updateMaterial(MaterialModel material) {
    return _materialsCollection.doc(material.id).update(material.toMap());
  }

  // Delete
  Future<void> deleteMaterial(String id) {
    return _materialsCollection.doc(id).delete();
  }
}
