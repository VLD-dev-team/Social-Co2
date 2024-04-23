import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/main.dart';
import 'package:social_co2/utils/requestsService.dart';

class ReccurentActivitiesProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = "";
  List<SCO2activity> reccurentActivities = [];

  ReccurentActivitiesProvider() {}

  Future<List<SCO2activity>> getReccurentActivities() async {
    error = "";
    isLoading = true;
    notifyListeners();

    // On obtient les données de l'utilisateur et on enlève les heures et minutes à la date demandé
    final String? token = await firebaseAuth.currentUser?.getIdToken();
    final String? userID = firebaseAuth.currentUser?.uid;

    // On prépare la requette get
    final headers = {'authorization': '$token', 'userid': '$userID'};
    final endpoint = "activities/favorite";

    // On effectue la requette
    final data = await requestService().get(endpoint, headers);

    // On vérifie l'absence d'erreurs
    if (!(data["error"] == null) && data["error"]) {
      try {
        error = 'error: ${data["error_message"].toString()}';
      } catch (e) {
        error = "error: unknown error";
      }

      isLoading = false;
      notifyListeners();

      return [];
    }

    // Liste d'activités
    List<SCO2activity> parsingList = [];
    for (var i = 0; i < data['activities'].length; i++) {
      parsingList.add(SCO2activity.fromJSON(data['activities'][i]));
    }

    // On met à jour la liste globale
    reccurentActivities.clear();
    reccurentActivities = parsingList;

    // On renvoie au widget
    isLoading = false;
    notifyListeners();

    return reccurentActivities;
  }
}
