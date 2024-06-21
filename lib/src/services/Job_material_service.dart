import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';

class JobMaterialService {
  final CollectionReference _jobMaterialCollection = FirebaseFirestore.instance.collection('material');

  Future<DocumentReference> addJobMaterial(JobMaterialModel material) {
      try {
      return _jobMaterialCollection.add(material.toJson());
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

  // Get All Material
  Future<List<JobMaterialModel>> getJobAllMaterial() async {
    try {
      QuerySnapshot querySnapshot = await _jobMaterialCollection.get();
      return querySnapshot.docs.map((doc) => JobMaterialModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all Material: $e');
    }
  }

  // Update Material
  Future<void> updateJobMaterial(JobMaterialModel material) async {
    try {
      if (material.documentId != null) {
        await _jobMaterialCollection.doc(material.documentId).update(material.toJson());
      } else {
        throw Exception('Error updating Material: Document ID is null');
      }
    } catch (e) {
      throw Exception('Error updating Material: $e');
    }
  }

  Stream<List<JobMaterialModel>> getJobMaterials() {
    return _jobMaterialCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => JobMaterialModel.fromDocument(doc)).toList();
    });
  }
  
  // Delete Material
  Future<void> deleteJobMaterial(String id) async {
    try {
      await _jobMaterialCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting Material: $e');
    }
  }
}
