import 'package:firebase_auth/firebase_auth.dart';

class SCO2activity {
  final int? activityID;
  final String userID;
  String activityType;
  int? activityCO2Impact;
  String activityName;
  DateTime activityTimestamp;

  SCO2activity({
    required this.userID,
    required this.activityType,
    required this.activityName,
    required this.activityTimestamp,
    this.activityID,
    this.activityCO2Impact,
  });

  factory SCO2activity.fromJSON(Map<String, dynamic> json) {
    return SCO2activity(
      activityID: json['activityID'],
      userID: json['userID'],
      activityType: json['activityType'],
      activityCO2Impact: json['activityCO2Impact'],
      activityName: json['activityName'],
      activityTimestamp: DateTime.parse(json['activityTimestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityID': activityID,
      'userID': userID,
      'activityType': activityType,
      'activityName': activityName,
      'activityTimestamp': activityTimestamp.toIso8601String(),
      if (activityCO2Impact != null) 'activityCO2Impact': activityCO2Impact,
    };
  }
}
