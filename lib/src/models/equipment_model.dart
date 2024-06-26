import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/models/identifiable.dart';

class EquipmentModel implements Identifiable {
  @override
  String? documentId; // Firestore document ID
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
      ratePerHour: (json['ratePerHour'] as num).toDouble(), // Ensures ratePerHour is converted to double
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
