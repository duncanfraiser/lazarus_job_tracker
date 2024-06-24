import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';

class JobMaterialService {
  final CollectionReference _jobMaterialCollection = FirebaseFirestore.instance.collection('material');

  Future<DocumentReference> addJobMaterial(JobMaterialModel material) async {
    try {
      return await _jobMaterialCollection.add(material.toJson());
    } catch (e) {
      throw Exception('Error adding material: $e');
    }
  }

  // Get Material by ID
  Future<JobMaterialModel?> getJobMaterialById(String id) async {
    try {
      DocumentSnapshot doc = await _jobMaterialCollection.doc(id).get();
      if (doc.exists) {
        return JobMaterialModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting material by ID: $e');
    }
  }

  // Get All Materials as a Stream
  Stream<List<JobMaterialModel>> getJobMaterials() {
    return _jobMaterialCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => JobMaterialModel.fromDocument(doc)).toList()
    );
  }

  // Get All Materials as a Future
  Future<List<JobMaterialModel>> getAllJobMaterials() async {
    try {
      QuerySnapshot querySnapshot = await _jobMaterialCollection.get();
      return querySnapshot.docs.map((doc) => JobMaterialModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all materials: $e');
    }
  }

  // Update Material
  Future<void> updateJobMaterial(JobMaterialModel material) async {
    try {
      if (material.documentId != null) {
        await _jobMaterialCollection.doc(material.documentId).update(material.toJson());
      } else {
        throw Exception('Error updating material: Document ID is null');
      }
    } catch (e) {
      throw Exception('Error updating material: $e');
    }
  }

  // Delete Material
  Future<void> deleteJobMaterial(String id) async {
    try {
      await _jobMaterialCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting material: $e');
    }
  }
}
