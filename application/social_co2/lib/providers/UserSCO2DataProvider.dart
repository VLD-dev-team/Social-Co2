import 'package:flutter/material.dart';
import 'package:social_co2/main.dart';
import 'package:social_co2/utils/requestsService.dart';

class UserSCO2DataProvider extends ChangeNotifier {
  int CurrentUserScore = 0;
  bool isLoading = false;
  String error = "";

  Future<int> getUserScore() async {
    isLoading = true;

    // On récupère le token de connexion
    final authToken = await firebaseAuth.currentUser!.getIdToken();

    // On fait la requette au server
    final data = await requestService().get("/user/", {"token": '$authToken'});

    // On analyse la réponse du server
    // En cas d'erreur, on renvoie erreur aux widgets
    if (data["error"] == true) {
      error = data["error_message"];
      isLoading = false;
      notifyListeners();
      return CurrentUserScore;
    }

    // Si pas d'erreur on met à jour le score pour toute l'appli et on met à jour le provider
    CurrentUserScore = int.parse(data["score"]);
    isLoading = false;
    notifyListeners();

    return CurrentUserScore;
  }
}
