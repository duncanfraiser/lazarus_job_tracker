import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String? documentId; // firestore document ID
  String fName;
  String lName;
  String billingAddress;
  String phone;
   String email;
  // Add other useful properties as needed

  // Constructor
  Client({
    this.documentId,
    required this.fName,
    required this.lName,
    required this.billingAddress,
    required this.phone,
    required this.email,
    // Initialize other properties
  });

  // From JSON
  factory Client.fromJson(Map<String, dynamic> json, String id) {
    return Client(
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
  factory Client.fromDocument(DocumentSnapshot doc) {
    return Client.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}