import 'package:cloud_firestore/cloud_firestore.dart';

class ClockTime {
  final DateTime clockIn;
  final DateTime clockOut;

  ClockTime({required this.clockIn, required this.clockOut});

  factory ClockTime.fromMap(Map<String, dynamic> data) {
    return ClockTime(
      clockIn: (data['clockIn'] as Timestamp).toDate(),
      clockOut: (data['clockOut'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clockIn': clockIn,
      'clockOut': clockOut,
    };
  }
}
