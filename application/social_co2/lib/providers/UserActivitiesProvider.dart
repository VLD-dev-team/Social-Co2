import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity/activity.dart';
import 'package:social_co2/main.dart';

class UserActivitiesProvider extends ChangeNotifier {
  List<SCO2activity> userActivities = [];
  bool isLoading = false;

  Future<List<SCO2activity>> getCurrentUserActivities(int index) async {
    isLoading = true;
    final String? token = await firebaseAuth.currentUser?.getIdToken();
    final String? userID = firebaseAuth.currentUser?.uid;

    await Future.delayed(const Duration(seconds: 1));

    print('Activités obtenues');
    userActivities.add(SCO2activity(
        activityID: 0,
        userID: '$userID',
        activityType: ActivityType.food,
        activityCO2Impact: 0,
        activityName: 'Repas du matin',
        activityTimestamp: DateTime(2004)));
    userActivities.add(SCO2activity(
        activityID: 1,
        userID: '$userID',
        activityType: ActivityType.food,
        activityCO2Impact: 0,
        activityName: 'Repas du midi',
        activityTimestamp: DateTime(2004)));
    userActivities.add(SCO2activity(
        activityID: 2,
        userID: '$userID',
        activityType: ActivityType.food,
        activityCO2Impact: 0,
        activityName: 'Repas de la nuit',
        activityTimestamp: DateTime(2004)));

    isLoading = false;
    return userActivities;
  }
}
