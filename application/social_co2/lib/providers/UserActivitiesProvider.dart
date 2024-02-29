import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity/activity.dart';
import 'package:http/http.dart' as http;
import 'package:social_co2/main.dart';

class UserActivitiesProvider extends ChangeNotifier {
  // TODO: supprimer ces activités quand les requettes seront opé
  List<SCO2activity> userActivities = [
    SCO2activity(
        activityID: 0,
        userID: '00',
        activityType: ActivityType.food,
        activityCO2Impact: 0,
        activityName: 'Repas du midi',
        activityTimestamp: DateTime(2004)),
    SCO2activity(
        activityID: 0,
        userID: '00',
        activityType: ActivityType.food,
        activityCO2Impact: 0,
        activityName: 'Repas du soir',
        activityTimestamp: DateTime(2004))
  ];
  bool isLoading = false;

  Future<List<SCO2activity>> getCurrentUserActivities(int index) async {
    isLoading = true;
    final String? token = await firebaseAuth.currentUser?.getIdToken();
    final String? userID = firebaseAuth.currentUser?.uid;

    print('get');
    userActivities.add(SCO2activity(
        activityID: 0,
        userID: '$userID',
        activityType: ActivityType.food,
        activityCO2Impact: 0,
        activityName: 'Repas de la nuit',
        activityTimestamp: DateTime(2004)));

    isLoading = false;
    return userActivities;

    /* 
    // On fait une requette au serveur
    final response = await http.get(
      Uri.parse('https://vld-group.com/api/user/activities?index=$index'),
      headers: <String, String>{
        'authorization': '$token',
        'id': '$userID',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final results = response.body;
      for (var i = 0; i < results.length; i++) {
        userActivities
            .add(SCO2activity.fromJSON(results[i] as Map<String, dynamic>));
      }
      isLoading = false;
      return userActivities;
    } else {
      throw Exception('Failed to create album.');
    } */
  }
}
