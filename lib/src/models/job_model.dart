import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String documentId;
  final String name;
  final String instructions;
  final List<String> equipmentIds;
  final String? clientId; // Add client ID
  // Add other useful properties as needed

  // Constructor
  JobModel({
    required this.documentId,
    required this.name,
    required this.instructions,
    required this.equipmentIds,
    this.clientId, // Add client ID
  });

  // From JSON
  factory JobModel.fromJson(Map<String, dynamic> json, String id) {
    return JobModel(
      documentId: id,
      name: json['name'],
      instructions: json['instructions'],
      equipmentIds: List<String>.from(json['equipmentIds'] ?? []),
      clientId: json['clientId'], // Add client ID
      // Initialize other properties
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'instructions': instructions,
      'equipmentIds': equipmentIds,
      'clientId': clientId, // Add client ID
      // Convert other properties
    };
  }

  // From Firestore Document
  factory JobModel.fromDocument(DocumentSnapshot doc) {
    return JobModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}