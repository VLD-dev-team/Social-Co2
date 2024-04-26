import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/utils/requestsService.dart';

class SCO2ReportProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = "";

  List<Map<String, dynamic>> report = [];
  int activityMaxImpactScore = 0;

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

    print(data);

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

    // On parse le rapport
    final List rawReport = data['rapport'];
    for (Map<String, dynamic> element in rawReport) {
      List<SCO2activity> activitylist = [];
      final rawActivityList = element['activities'];
      for (Map<String, dynamic> activity in rawActivityList) {
        activitylist.add(SCO2activity.fromJSON(activity));
      }
      report.add({
        "day": element["day"].toString(),
        "activities": activitylist,
        "impact": element["impact"]
      });
    }
    // On récupère l'activité de la semaine
    activityMaxImpactScore = data['maximum'];

    // On termine la fonction
    isLoading = false;
    notifyListeners();
    return "Report refreshed from the server";
  }
}
