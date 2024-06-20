import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';

class JobService {
  final CollectionReference jobCollection = FirebaseFirestore.instance.collection('job');

  // Add Job
  Future<void> addJob(JobModel job) async {
    try {
      await jobCollection.add(job.toJson());
    } catch (e) {
      throw Exception('Error adding job: $e');
    }
  }

  // Get Job by ID
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

  // Get All Jobs
  Future<List<JobModel>> getAllJobs() async {
    try {
      QuerySnapshot querySnapshot = await jobCollection.get();
      return querySnapshot.docs.map((doc) => JobModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all jobs: $e');
    }
  }

  // Get Jobs as Stream
  Stream<List<JobModel>> getJobs() {
    return jobCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => JobModel.fromDocument(doc)).toList();
    });
  }

  // Update Job
  Future<void> updateJob(JobModel job) async {
    try {
      await jobCollection.doc(job.documentId).update(job.toJson());
    } catch (e) {
      throw Exception('Error updating job: $e');
    }
  }

  // Delete Job
  Future<void> deleteJob(String id) async {
    try {
      await jobCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting job: $e');
    }
  }
}
