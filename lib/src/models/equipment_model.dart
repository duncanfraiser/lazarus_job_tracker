import 'package:cloud_firestore/cloud_firestore.dart';

class Equipment {
  String? documentId; // firestore document ID
  String name;
  double price;
  String description;
  // Add other useful properties as needed

  // Constructor
  Equipment({
    this.documentId,
    required this.name,
    required this.price,
    required this.description,
    // Initialize other properties
  });

  // From JSON
  factory Equipment.fromJson(Map<String, dynamic> json, String id) {
    return Equipment(
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
  factory Equipment.fromDocument(DocumentSnapshot doc) {
    return Equipment.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}