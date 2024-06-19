import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';

class JobService {
  final CollectionReference jobCollection = FirebaseFirestore.instance.collection('job');

  // Add Client
  Future<void> addJob(JobModel job) async {
    try {
      await jobCollection.add(job.toJson());
    } catch (e) {
      throw Exception('Error adding job: $e');
    }
  }

  // Get Client by ID
  Future<JobModel?> getJobById(String id) async {
    try {
      DocumentSnapshot doc = await jobCollection.doc(id).get();
      if (doc.exists) {
        return JobModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting job by ID: $e');
    }
  }

  // Get All Client
  Future<List<JobModel>> getAllJob() async {
    try {
      QuerySnapshot querySnapshot = await jobCollection.get();
      return querySnapshot.docs.map((doc) => JobModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all jobs: $e');
    }
  }

  // Update Client
  Future<void> updateJob(JobModel job) async {
    try {
      if (job.documentId != null) {
        await jobCollection.doc(job.documentId).update(job.toJson());
      } else {
        throw Exception('Error updating client: Document ID is null');
      }
    } catch (e) {
      throw Exception('Error updating client: $e');
    }
  }

  // Delete Equipment
  Future<void> deleteJob(String id) async {
    try {
      await jobCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting job: $e');
    }
  }
}
