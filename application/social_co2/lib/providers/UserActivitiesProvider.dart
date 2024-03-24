import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity/activity.dart';
import 'package:social_co2/collections/activitiesData.dart';
import 'package:social_co2/main.dart';
import 'package:social_co2/utils/requestsService.dart';

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
        .indexWhere((element) => element['type'] == "purchase")]['label'];
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
      activityType: 'build',
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
      activityType: 'route',
      activityName: 'Trajet de $time',
      activityTimestamp: DateTime.now(),
      activityVehicle: vehicule,
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
    final headers = {'autorization': '$token'};

    // On effectue la requette
    const endpoint = "activity/post/";
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

    // Si pas d'erreur on traite la requette
    final SCO2activity newActivity = SCO2activity.fromJSON(data);

    // On met à jour les widget
    isPosting = false;
    error = "";
    notifyListeners();

    // On met à jour la liste des activités
    getCurrentUserActivitiesByDate(newActivity.activityTimestamp);

    // On retourne l'activité nouvellement créée
    return newActivity;
  }
}
