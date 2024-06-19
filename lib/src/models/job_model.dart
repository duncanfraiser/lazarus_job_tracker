import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  String? documentId; // firestore document ID
  String name;
  String instructions;
  List<String> equipmentIds;
  // Add other useful properties as needed

  // Constructor
  JobModel({
    this.documentId,
    required this.name,
    required this.instructions,
    required this.equipmentIds,
    
    // Initialize other properties
  });

  // From JSON
  factory JobModel.fromJson(Map<String, dynamic> json, String id) {
    return JobModel(
      documentId: id,
      name: json['name'],
      instructions: json['instructions'],
      equipmentIds: List<String>.from(json['equipmentIds'] ?? []),
      // Initialize other properties
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'instructions': instructions,
      'equipmentIds': equipmentIds,
      // Convert other properties
    };
  }

  // From Firestore Document
  factory JobModel.fromDocument(DocumentSnapshot doc) {
    return JobModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}