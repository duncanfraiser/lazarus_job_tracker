import 'package:cloud_firestore/cloud_firestore.dart';

class JobMaterialModel {
  String? documentId; // Firestore document ID
  String name;
  double price;
  String description;
  // Add other useful properties as needed

  // Constructor
  JobMaterialModel({
    this.documentId,
    required this.name,
    required this.price,
    required this.description,
    // Initialize other properties
  });

  // From JSON
  factory JobMaterialModel.fromJson(Map<String, dynamic> json, String id) {
    return JobMaterialModel(
      documentId: id,
      name: json['name'],
      price: (json['price'] as num).toDouble(), // Ensures price is converted to double
      description: json['description'],
      // Initialize other properties
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      // Convert other properties
    };
  }

  // From Firestore Document
  factory JobMaterialModel.fromDocument(DocumentSnapshot doc) {
    return JobMaterialModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  // Getter for id
  String get id => documentId ?? '';
}
