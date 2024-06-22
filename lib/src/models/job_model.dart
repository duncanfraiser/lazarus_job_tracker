import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  String? documentId;
  String name;
  String instructions;
  String clientId;
  List<String> equipmentIds;
  List<String> jobMaterialIds;
  Map<String, List<EquipmentUsage>> equipmentUsage;
  Map<String, List<JobMaterialUsage>> jobMaterialUsage;

  JobModel({
    this.documentId,
    required this.name,
    required this.instructions,
    required this.clientId,
    required this.equipmentIds,
    required this.jobMaterialIds,
    required this.equipmentUsage,
    required this.jobMaterialUsage,
  });

  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return JobModel(
      documentId: doc.id,
      name: data['name'] ?? '',
      instructions: data['instructions'] ?? '',
      clientId: data['clientId'] ?? '',
      equipmentIds: List<String>.from(data['equipmentIds'] ?? []),
      jobMaterialIds: List<String>.from(data['jobMaterialIds'] ?? []),
      equipmentUsage: (data['equipmentUsage'] ?? {}).map<String, List<EquipmentUsage>>(
        (key, value) => MapEntry(key, (value as List).map((e) => EquipmentUsage.fromMap(e)).toList()),
      ),
      jobMaterialUsage: (data['jobMaterialUsage'] ?? {}).map<String, List<JobMaterialUsage>>(
        (key, value) => MapEntry(key, (value as List).map((e) => JobMaterialUsage.fromMap(e)).toList()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'instructions': instructions,
      'clientId': clientId,
      'equipmentIds': equipmentIds,
      'jobMaterialIds': jobMaterialIds,
      'equipmentUsage': equipmentUsage.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
      'jobMaterialUsage': jobMaterialUsage.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
    };
  }
}

class EquipmentUsage {
  DateTime date;
  double hours;

  EquipmentUsage({
    required this.date,
    required this.hours,
  });

  factory EquipmentUsage.fromMap(Map<String, dynamic> data) {
    return EquipmentUsage(
      date: (data['date'] as Timestamp).toDate(),
      hours: data['hours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hours': hours,
    };
  }
}

class JobMaterialUsage {
  DateTime date;
  double quantity;

  JobMaterialUsage({
    required this.date,
    required this.quantity,
  });

  factory JobMaterialUsage.fromMap(Map<String, dynamic> data) {
    return JobMaterialUsage(
      date: (data['date'] as Timestamp).toDate(),
      quantity: data['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'quantity': quantity,
    };
  }
}
