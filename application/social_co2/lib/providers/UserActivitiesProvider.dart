import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/collections/activitiesData.dart';
import 'package:social_co2/main.dart';
import 'package:social_co2/utils/requestsService.dart';

class UserActivitiesProvider extends ChangeNotifier {
  Map<DateTime, String> userRecapPhrasePerDays =
      {}; // Liste des phrases récapituatives par jour
  Map<DateTime, List<SCO2activity>> userActivitiesPerDays =
      {}; // Liste des activités triés par jour

  // Variable spécifique à l'utilisation du provider et des requettes
  bool isLoading = false;
  bool isPosting = false;
  String error = "";

  UserActivitiesProvider() {
    initData();
  }

  Future<void> initData() async {
    // controller de la date courante
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // controller de la date d'hier
    DateTime yesterday = today.subtract(const Duration(days: 1));

    // Obtention des informations necessaire au lancement de l'écran d'accueil depuis le serveur
    getCurrentUserActivitiesByDate(today);
    getCurrentUserActivitiesByDate(yesterday);
  }

  Future<List<SCO2activity>> getCurrentUserActivitiesByDate(
      DateTime date) async {
    error = "";
    isLoading = true;
    notifyListeners();

    // On obtient les données de l'utilisateur et on enlève les heures et minutes à la date demandé
    final String? token = await firebaseAuth.currentUser?.getIdToken();
    final String? userID = firebaseAuth.currentUser?.uid;
    final DateTime parsedDate = DateTime(date.year, date.month, date.day);

    // On prépare la requette get
    final headers = {'authorization': '$token', 'userid': '$userID'};
    final endpoint =
        "user/activities?currentTimestamp=${parsedDate.toIso8601String()}";

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

    print(data);

    // Si pas d'erreur on enregistre les données temporairement
    // Phrase de récap
    String? phrase = data['phrase'];
    if (phrase == null || phrase == "") {
      phrase = "Pas d'activité pour ce jour.";
    }
    userRecapPhrasePerDays.update(
      parsedDate,
      (value) => phrase!,
      ifAbsent: () => phrase!,
    );
    // Liste d'activités
    List<SCO2activity> parsingList = [];
    for (var i = 0; i < data['activities'].length; i++) {
      parsingList.add(SCO2activity.fromJSON(data['activities'][i]));
    }
    userActivitiesPerDays.update(
      parsedDate,
      (value) => parsingList,
      ifAbsent: () => parsingList,
    );

    // On renvoie les données aux widgets et à l'appel de la fonction
    isLoading = false;
    notifyListeners();
    return userActivitiesPerDays[parsedDate]!;
  }

  Future<SCO2activity> postEmailActivity() async {
    final SCO2activity activity = SCO2activity(
        activityType: "mail",
        activityName: "Nettoyage de boite email",
        activityTimestamp: DateTime.now());
    // On envoie l'activité
    final data = await sendActivity(activity);
    return data;
  }

  Future<SCO2activity> postMealActivity(String mealIngredients) async {
    final String time = '${DateTime.now().hour}:${DateTime.now().minute}';
    final SCO2activity activity = SCO2activity(
        activityType: 'meal',
        activityName: 'Repas de $time',
        activityTimestamp: DateTime.now(),
        activityMealIngredients: mealIngredients);
    // On envoie l'activité
    final data = await sendActivity(activity);
    return data;
  }

  Future<SCO2activity> postPurchaseActivity(String purchaseType) async {
    final String time = '${DateTime.now().hour}:${DateTime.now().minute}';
    final String label = purchases[purchases
        .indexWhere((element) => element['type'] == purchaseType)]['label'];
    final SCO2activity activity = SCO2activity(
      activityType: 'purchase',
      activityName: 'Achat de $time - $label',
      activityTimestamp: DateTime.now(),
      activityPurchase: purchaseType,
    );
    // On envoie l'activité
    final data = await sendActivity(activity);
    return data;
  }

  Future<SCO2activity> postBuildActivity(String buildType) async {
    final String time = '${DateTime.now().hour}:${DateTime.now().minute}';
    final SCO2activity activity = SCO2activity(
      activityType: 'renovation',
      activityName: 'Bricolage de $time',
      activityTimestamp: DateTime.now(),
      activityBuild: buildType,
    );
    // On envoie l'activité
    final data = await sendActivity(activity);
    return data;
  }

  Future<SCO2activity> postRouteActivity(
      String vehicule, double distance) async {
    final String time = '${DateTime.now().hour}:${DateTime.now().minute}';
    final SCO2activity activity = SCO2activity(
      activityType: 'trip',
      activityName: 'Trajet de $time',
      activityTimestamp: DateTime.now(),
      activityVehicule: vehicule,
      activityDistance: distance,
    );
    // On envoie l'activité
    final data = await sendActivity(activity);
    return data;
  }

  Future<SCO2activity> sendActivity(SCO2activity activity) async {
    isPosting = true;
    notifyListeners();

    // On récupère les infos de l'utilisateur connecté
    final String? token = await firebaseAuth.currentUser?.getIdToken();
    final String? userID = firebaseAuth.currentUser?.uid;

    // On construit les headers et le body de la requette
    final body = activity.toJson();
    final headers = {'authorization': '$token', 'userid': '$userID'};

    // On effectue la requette
    const endpoint = "activity";
    final data = await requestService().post(endpoint, headers, body);

    // On analyse la réponse du server
    // En cas d'erreur, on renvoie erreur aux widgets
    if (data["error"] == true) {
      try {
        error = 'error: ${data["error_message"].toString()}';
      } catch (e) {
        error = "error: unknown error";
      }

      isPosting = false;
      notifyListeners();

      return activity;
    }

    // On met à jour les widget
    isPosting = false;
    error = "";
    notifyListeners();

    // On met à jour la liste des activités
    getCurrentUserActivitiesByDate(activity.activityTimestamp);

    // On retourne l'activité nouvellement créée
    return activity;
  }
}
