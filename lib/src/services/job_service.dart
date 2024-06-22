import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';

class JobService {
  final CollectionReference jobCollection = FirebaseFirestore.instance.collection('jobs');

  Future<void> addJob(JobModel job) async {
    try {
      await jobCollection.add(job.toJson());
    } catch (e) {
      throw Exception('Error adding job: $e');
    }
  }

  Future<JobModel?> getJobById(String id) async {
    try {
      DocumentSnapshot doc = await jobCollection.doc(id).get();
      if (doc.exists) {
        return JobModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting job: $e');
    }
  }

  Stream<List<JobModel>> getJobs() {
    return jobCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => JobModel.fromFirestore(doc)).toList());
  }

  Future<void> updateJob(JobModel job) async {
    try {
      await jobCollection.doc(job.documentId).update(job.toJson());
    } catch (e) {
      throw Exception('Error updating job: $e');
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      await jobCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting job: $e');
    }
  }
}
