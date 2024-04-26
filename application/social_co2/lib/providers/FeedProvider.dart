import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/utils/requestsService.dart';

class FeedProvider extends ChangeNotifier {
  // Variables globales au provider
  List<SCO2Post> feed = [];
  Map<String, dynamic> postComments = {};
  String error = "";
  bool loading = false;

  FeedProvider() {
    refreshFeed();
  }

  Future<void> refreshFeed() async {
    getFeed();
  }

  Future<List<SCO2Post>> getFeed() async {
    // On initialise la liste et le provider
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

    print(data['feed']);

    // On transforme les données en liste de post SCO2
    if (data['feed'] != []) {
      for (var i = 0; i < data['feed'].length; i++) {
        final post =
            SCO2Post.fromJSON(Map<String, dynamic>.from(data["feed"][i]));
        newFeed.add(post);
      }
    }

    print("feed $newFeed");
    feed = newFeed;

    // On termine la requette
    loading = false;
    notifyListeners();
    return feed;
  }

  Future<int> likePost(postID) async {
    error = "";
    loading = true;
    notifyListeners();

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().get("social/like", {
      "authorization": '$authToken',
      'userid': userID,
    });

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
      return 0;
    }

    // On analyse les données renvoyés par le serveur et on affiche le like
    // TODO: analyser la réponse serveur

    return 0;
  }

  Future<List<Map<String, dynamic>>> getPostComment(postID) async {
    error = "";
    loading = true;
    notifyListeners();

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().get("social/like", {
      "authorization": '$authToken',
      'userid': userID,
    });

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
      return [];
    }

    postComments.update(postID, (value) => data['comments'],
        ifAbsent: () => data['comments']);

    return [];
  }
}