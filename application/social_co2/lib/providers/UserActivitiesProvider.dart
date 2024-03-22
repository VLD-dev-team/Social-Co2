import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity/activity.dart';
import 'package:social_co2/main.dart';

class UserActivitiesProvider extends ChangeNotifier {
  List<SCO2activity> userActivities = []; // Liste des activités en "vrac"
  Map<DateTime, List<SCO2activity>> userActivitiesPerDays =
      {}; // Liste des activités triés par jour

  // Variable spécifique à l'utilisation du provider et des requettes
  bool isLoading = false;
  bool isPosting = false;
  String error = "";

  Future<List<SCO2activity>> getCurrentUserActivities(int index) async {
    isLoading = true;
    final String? token = await firebaseAuth.currentUser?.getIdToken();
    final String? userID = firebaseAuth.currentUser?.uid;

    await Future.delayed(const Duration(seconds: 3));

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    userActivitiesPerDays.addAll({
      today: [
        SCO2activity(
            userID: '$userID',
            activityType: "journey",
            activityName: "Trajet 1",
            activityTimestamp: today)
      ],
      today.subtract(const Duration(days: 1)): [
        SCO2activity(
            userID: '$userID',
            activityType: "journey",
            activityName: "Trajet 2",
            activityTimestamp: today.subtract(const Duration(days: 1)))
      ]
    });

    isLoading = false;
    notifyListeners();
    return userActivities;
  }

  Future<List<SCO2activity>> getCurrentUserActivitiesByDate(
      DateTime date) async {
    isLoading = true;
    final String? token = await firebaseAuth.currentUser?.getIdToken();
    final String? userID = firebaseAuth.currentUser?.uid;

    if (userActivitiesPerDays[date] == null) {
      userActivitiesPerDays.addAll({
        date: [
          SCO2activity(
              userID: '$userID',
              activityType: "journey",
              activityName: "Trajet",
              activityTimestamp: date)
        ]
      });
    } else {
      userActivitiesPerDays[date]!.add(SCO2activity(
          userID: '$userID',
          activityType: "journey",
          activityName: "Trajet",
          activityTimestamp: date));
    }

    await Future.delayed(const Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
    return userActivitiesPerDays[date]!;
  }

  Future<SCO2activity> postEmailActivity() async {
    return SCO2activity(
        userID: "000",
        activityType: "type",
        activityName: "1",
        activityTimestamp: DateTime.now());
  }

  Future<SCO2activity> postMealActivity(String meal_type) async {
    return SCO2activity(
        userID: "000",
        activityType: "type",
        activityName: "1",
        activityTimestamp: DateTime.now());
  }

  Future<SCO2activity> postPurchaseActivity(String purchase_type) async {
    return SCO2activity(
        userID: "000",
        activityType: "type",
        activityName: "1",
        activityTimestamp: DateTime.now());
  }

  Future<SCO2activity> postBuildActivity(String build_type) async {
    return SCO2activity(
        userID: "000",
        activityType: "type",
        activityName: "1",
        activityTimestamp: DateTime.now());
  }

  Future<SCO2activity> postRouteActivity(String vehicule, double distance) async {
    return SCO2activity(
        userID: "000",
        activityType: "type",
        activityName: "1",
        activityTimestamp: DateTime.now());
  }
}
