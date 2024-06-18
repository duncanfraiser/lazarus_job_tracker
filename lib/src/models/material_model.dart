import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  String? documentId; // firestore document ID
  String name;
  double price;
  String description;
  // Add other useful properties as needed

  // Constructor
  MaterialModel({
    this.documentId,
    required this.name,
    required this.price,
    required this.description,
    // Initialize other properties
  });

  // From JSON
  factory MaterialModel.fromJson(Map<String, dynamic> json, String id) {
    return MaterialModel(
      documentId: id,
      name: json['name'],
      price: json['price'],
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
  factory MaterialModel.fromDocument(DocumentSnapshot doc) {
    return MaterialModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}