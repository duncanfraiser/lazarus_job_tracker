import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentModel {
  String? documentId; // firestore document ID
  String name;
  double ratePerHour;
  String description;
  // Add other useful properties as needed

  // Constructor
  EquipmentModel({
    this.documentId,
    required this.name,
    required this.ratePerHour,
    required this.description,
    // Initialize other properties
  });

  // From JSON
  factory EquipmentModel.fromJson(Map<String, dynamic> json, String id) {
    return EquipmentModel(
      documentId: id,
      name: json['name'],
      ratePerHour: json['ratePerHour'],
      description: json['description'],
      // Initialize other properties
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
      'description': description,
      // Convert other properties
    };
  }

  // From Firestore Document
  factory EquipmentModel.fromDocument(DocumentSnapshot doc) {
    return EquipmentModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}
