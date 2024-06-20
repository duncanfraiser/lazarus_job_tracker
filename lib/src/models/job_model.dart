import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String documentId;
  final String name;
  final String instructions;
  final List<String> equipmentIds;
  final List<String> materialIds;
  final String? clientId;
  final Map<String, List<EquipmentUsage>> equipmentUsage;

  // Constructor
  JobModel({
    required this.documentId,
    required this.name,
    required this.instructions,
    required this.equipmentIds,
    required this.materialIds,
    this.clientId,
    Map<String, List<EquipmentUsage>>? equipmentUsage,
  }) : equipmentUsage = equipmentUsage ?? {};

  // From JSON
  factory JobModel.fromJson(Map<String, dynamic> json, String id) {
    return JobModel(
      documentId: id,
      name: json['name'],
      instructions: json['instructions'],
      equipmentIds: List<String>.from(json['equipmentIds'] ?? []),
      materialIds: List<String>.from(json['materialIds'] ?? []),
      clientId: json['clientId'],
      equipmentUsage: (json['equipmentUsage'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, List<EquipmentUsage>.from((v as List).map((e) => EquipmentUsage.fromJson(e))))) ?? {},
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'instructions': instructions,
      'equipmentIds': equipmentIds,
      'materialIds': materialIds,
      'clientId': clientId,
      'equipmentUsage': equipmentUsage.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList())),
    };
  }

  // From Firestore Document
  factory JobModel.fromDocument(DocumentSnapshot doc) {
    return JobModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }
}

class EquipmentUsage {
  final DateTime date;
  final double hours;

  EquipmentUsage({
    required this.date,
    required this.hours,
  });

  factory EquipmentUsage.fromJson(Map<String, dynamic> json) {
    return EquipmentUsage(
      date: (json['date'] as Timestamp).toDate(),
      hours: json['hours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hours': hours,
    };
  }
}
