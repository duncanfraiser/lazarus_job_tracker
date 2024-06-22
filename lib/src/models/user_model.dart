import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EmergencyContact {
  final String name;
  final String phone;

  EmergencyContact({required this.name, required this.phone});

  factory EmergencyContact.fromMap(Map<String, dynamic> data) {
    return EmergencyContact(
      name: data['name'],
      phone: data['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class UserModel with ChangeNotifier {
  String? documentId; // Add this property
  String id;
  String firstName;
  String lastName;
  String email;
  String companyName;
  String userRole;
  String phoneNumber;
  String address;
  List<EmergencyContact> emergencyContacts;
  bool isLoggedIn;

  UserModel({
    this.documentId, // Add this property
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.companyName,
    required this.userRole,
    required this.phoneNumber,
    required this.address,
    required this.emergencyContacts,
    this.isLoggedIn = false,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      documentId: doc.id, // Set documentId
      id: data['id'] ?? '', // Use data['id'] or provide a default value
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      companyName: data['companyName'],
      userRole: data['userRole'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      emergencyContacts: (data['emergencyContacts'] as List)
          .map((e) => EmergencyContact.fromMap(e))
          .toList(),
      isLoggedIn: data['isLoggedIn'] ?? false, // Provide default value
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include the id property
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'companyName': companyName,
      'userRole': userRole,
      'phoneNumber': phoneNumber,
      'address': address,
      'emergencyContacts': emergencyContacts.map((e) => e.toMap()).toList(),
      'isLoggedIn': isLoggedIn,
    };
  }

  // Setters
  set updateFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  set updateLastName(String value) {
    lastName = value;
    notifyListeners();
  }

  set updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  set updateCompanyName(String value) {
    companyName = value;
    notifyListeners();
  }

  set updateUserRole(String value) {
    userRole = value;
    notifyListeners();
  }

  set updatePhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  set updateAddress(String value) {
    address = value;
    notifyListeners();
  }

  set updateEmergencyContacts(List<EmergencyContact> value) {
    emergencyContacts = value;
    notifyListeners();
  }

  set updateIsLoggedIn(bool value) {
    isLoggedIn = value;
    notifyListeners();
  }

  // Getters
  String get getId => id;
  String get getFirstName => firstName;
  String get getLastName => lastName;
  String get getEmail => email;
  String get getCompanyName => companyName;
  String get getUserRole => userRole;
  String get getPhoneNumber => phoneNumber;
  String get getAddress => address;
  List<EmergencyContact> get getEmergencyContacts => emergencyContacts;
  bool get getIsLoggedIn => isLoggedIn;
}
