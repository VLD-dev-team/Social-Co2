import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/utils/requestsService.dart';

class SCO2ReportProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = "";

  int todayImpact = 0;
  int activityMaxImpactScore = 0;
  SCO2activity? activityMaxImpact;

  SCO2ReportProvider() {
    refreshData();
  }

  Future<void> refreshData() async {
    getSCO2Report();
  }

  Future<String> getSCO2Report() async {
    error = "";
    isLoading = true;
    notifyListeners();

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().get(
      "rapport",
      {
        "authorization": '$authToken',
        'userid': userID,
      },
    );

    // On analyse la réponse du server
    // En cas d'erreur, on renvoie erreur aux widgets
    if (data["error"] == true) {
      try {
        error = 'error: ${data["error_message"].toString()}';
      } catch (e) {
        error = "error: unknown error";
      }

      isLoading = false;
      notifyListeners();
      return error;
    }

    // On parse les données
    Map impact = data['impact'];
    todayImpact = int.parse(impact.values.first.toString());
    activityMaxImpact = data['maximum'];

    final DateTime date = DateTime.now();
    final DateTime parsedDate = DateTime(date.year, date.month, date.day);

    activityMaxImpact = UserActivitiesProvider()
        .userActivitiesPerDays[parsedDate]!
        .firstWhere(
            (element) => element.activityCO2Impact == activityMaxImpactScore);

    print(todayImpact);
    print(activityMaxImpact);
    print(activityMaxImpactScore);

    return todayImpact.toString();
  }
}
