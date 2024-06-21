import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_usage_dialog.dart';

class JobModel {
  final String documentId;
  final String name;
  final String instructions;
  final List<String> equipmentIds;
  final List<String> jobMaterialIds;
  final String? clientId;
  final Map<String, List<EquipmentUsage>> equipmentUsage;
  final Map<String, List<JobMaterialUsage>> jobMaterialUsage; // Add this field

  JobModel({
    required this.documentId,
    required this.name,
    required this.instructions,
    required this.equipmentIds,
    required this.jobMaterialIds,
    this.clientId,
    Map<String, List<EquipmentUsage>>? equipmentUsage,
    Map<String, List<JobMaterialUsage>>? jobMaterialUsage, // Add this field
  })  : equipmentUsage = equipmentUsage ?? {},
        jobMaterialUsage = jobMaterialUsage ?? {}; // Initialize

  factory JobModel.fromJson(Map<String, dynamic> json, String id) {
    return JobModel(
      documentId: id,
      name: json['name'],
      instructions: json['instructions'],
      equipmentIds: List<String>.from(json['equipmentIds'] ?? []),
      jobMaterialIds: List<String>.from(json['materialIds'] ?? []),
      clientId: json['clientId'],
      equipmentUsage: (json['equipmentUsage'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, List<EquipmentUsage>.from((v as List).map((e) => EquipmentUsage.fromJson(e)))))
          ?? {},
      jobMaterialUsage: (json['jobMaterialUsage'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, List<JobMaterialUsage>.from((v as List).map((e) => JobMaterialUsage.fromJson(e)))))
          ?? {}, // Add this field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'instructions': instructions,
      'equipmentIds': equipmentIds,
      'materialIds': jobMaterialIds,
      'clientId': clientId,
      'equipmentUsage': equipmentUsage.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList())),
      'jobMaterialUsage': jobMaterialUsage.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList())), // Add this field
    };
  }

  factory JobModel.fromDocument(DocumentSnapshot doc) {
    return JobModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}

class EquipmentUsage {
  final DateTime date;
  final double hours;

  EquipmentUsage({
    required this.date,
    required this.hours,
  });

  factory EquipmentUsage.fromJson(Map<String, dynamic> json) {
    return EquipmentUsage(
      date: (json['date'] as Timestamp).toDate(),
      hours: json['hours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hours': hours,
    };
  }
}
