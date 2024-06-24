import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lazarus_job_tracker/src/models/clock_time_model.dart'; // Import ClockTime from the correct file

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
  String? documentId;
  String id;
  String firstName;
  String lastName;
  String email;
  String companyName;
  String userRole;
  String phoneNumber;
  String address;
  List<EmergencyContact> emergencyContacts;
  List<ClockTime> clockTimes; // Ensure it refers to ClockTime from the correct file
  bool isLoggedIn;

  UserModel({
    this.documentId,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.companyName,
    required this.userRole,
    required this.phoneNumber,
    required this.address,
    required this.emergencyContacts,
    required this.clockTimes,
    this.isLoggedIn = false,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      documentId: doc.id,
      id: data['id'] ?? '',
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
      clockTimes: (data['clockTimes'] as List)
          .map((e) => ClockTime.fromMap(e))
          .toList(),
      isLoggedIn: data['isLoggedIn'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'companyName': companyName,
      'userRole': userRole,
      'phoneNumber': phoneNumber,
      'address': address,
      'emergencyContacts': emergencyContacts.map((e) => e.toMap()).toList(),
      'clockTimes': clockTimes.map((e) => e.toJson()).toList(),
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

  set updateClockTimes(List<ClockTime> value) {
    clockTimes = value;
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
  List<ClockTime> get getClockTimes => clockTimes;
  bool get getIsLoggedIn => isLoggedIn;
}
