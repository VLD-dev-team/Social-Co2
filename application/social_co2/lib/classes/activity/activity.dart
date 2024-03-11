import 'package:firebase_auth/firebase_auth.dart';

enum ActivityType { route, food }

class SCO2activity {
  late final int activityID;
  late final String userID;
  late ActivityType activityType;
  late int activityCO2Impact;
  late String activityName;
  late DateTime activityTimestamp;

  SCO2activity({
    required this.activityID,
    required this.userID, 
    required this.activityType,
    required this.activityCO2Impact,
    required this.activityName,
    required this.activityTimestamp,
  });

  SCO2activity.fromJSON(Map<String, dynamic> json) {
    activityID = json['activityID'];
    userID = json['userID'];
    activityType = json['activityType'];
    activityCO2Impact = json['activityCO2Impact'];
    activityName = json['activityName'];
    activityTimestamp = json['activityTimestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityID'] = activityID;
    data['userID'] = userID;
    data['activityType'] = activityType;
    data['activityCO2Impact'] = activityCO2Impact;
    data['activityName'] = activityName;
    data['activityTimestamp'] = activityTimestamp;
    return data;
  }
}
