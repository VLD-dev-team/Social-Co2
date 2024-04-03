import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/utils/requestsService.dart';

class SearchProvider extends ChangeNotifier {
  List<dynamic> searchResults = [];
  bool searching = true;
  String error = "";

  Future<List<dynamic>> search(query) async {
    print("Recherche lancé pour $query");

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().get("friends/search?idSearch=$query", {
      "authorization": '$authToken',
      'userid': '$userID',
    });

    // On analyse la réponse du server
    // En cas d'erreur, on renvoie erreur aux widgets
    if (data["error"] == true) {
      try {
        error = 'error: ${data["error_message"].toString()}';
      } catch (e) {
        error = "error: unknown error";
      }

      searching = false;
      notifyListeners();
      return searchResults;
    }

    // Si des résultats nous parviennent, on les parse
    searchResults = []; // On supprime les précédents résultats
    if (data['results'] != []) {
      searchResults
          .addAll(data['results']); // On ajoute les nouveaux s'il y en a
    }

    searching = false;
    notifyListeners();
    return searchResults;
  }
}
