import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String documentId;
  final String name;
  final String instructions;
  final List<String> equipmentIds;
  final List<String> materialIds; // Add material IDs
  final String? clientId; // Add client ID

  // Constructor
  JobModel({
    required this.documentId,
    required this.name,
    required this.instructions,
    required this.equipmentIds,
    required this.materialIds, // Add material IDs
    this.clientId, // Add client ID
  });

  // From JSON
  factory JobModel.fromJson(Map<String, dynamic> json, String id) {
    return JobModel(
      documentId: id,
      name: json['name'],
      instructions: json['instructions'],
      equipmentIds: List<String>.from(json['equipmentIds'] ?? []),
      materialIds: List<String>.from(json['materialIds'] ?? []), // Add material IDs
      clientId: json['clientId'], // Add client ID
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'instructions': instructions,
      'equipmentIds': equipmentIds,
      'materialIds': materialIds, // Add material IDs
      'clientId': clientId, // Add client ID
    };
  }

  // From Firestore Document
  factory JobModel.fromDocument(DocumentSnapshot doc) {
    return JobModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}
