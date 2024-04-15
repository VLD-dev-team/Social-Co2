import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/utils/requestsService.dart';

class FeedProvider extends ChangeNotifier {
  // Variables globales au provider
  List<SCO2Post> feed = [];
  String error = "";
  bool loading = false;

  FeedProvider() {
    print("Obtention du feed");
    refreshFeed();
  }

  Future<void> refreshFeed() async {
    getFeed();
  }

  Future<List<SCO2Post>> getFeed() async {
    // On initialise la liste et le provider
    print('go feed');

    error = "";
    loading = true;
    notifyListeners();
    List<SCO2Post> newFeed = [];

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().get("social/feed", {
      "authorization": '$authToken',
      'userid': userID,
    });

    print(data);

    // On analyse la réponse du server
    // En cas d'erreur, on renvoie erreur aux widgets
    if (data["error"] == true) {
      try {
        error = 'error: ${data["error_message"].toString()}';
      } catch (e) {
        error = "error: unknown error";
      }

      loading = false;
      notifyListeners();
      return newFeed;
    }

    // On transforme les données en liste d'utilisateur SCO2
    if (data['feed'] != []) {
      for (var i = 0; i < data['feed'].length; i++) {
        final userData = SCO2Post.fromJSON(data['feed'][i]);
        newFeed.add(userData);
      }
    }

    print("feed $newFeed");

    // On termine la requette
    loading = false;
    notifyListeners();
    return newFeed;
  }
}
