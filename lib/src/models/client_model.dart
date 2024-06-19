import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  String? documentId; // firestore document ID
  String fName;
  String lName;
  String billingAddress;
  String phone;
   String email;
  // Add other useful properties as needed

  // Constructor
  ClientModel({
    this.documentId,
    required this.fName,
    required this.lName,
    required this.billingAddress,
    required this.phone,
    required this.email,
    // Initialize other properties
  });

  // From JSON
  factory ClientModel.fromJson(Map<String, dynamic> json, String id) {
    return ClientModel(
      documentId: id,
      fName: json['fName'],
      lName: json['lName'],
      billingAddress: json['billingAddress'],
      phone: json['phone'],
       email: json['email'],
      // Initialize other properties
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'fName': fName,
      'lName': lName,
      'billingAddress': billingAddress,
      'phone': phone,
      'email': email,
      // Convert other properties
    };
  }

  // From Firestore Document
  factory ClientModel.fromDocument(DocumentSnapshot doc) {
    return ClientModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}