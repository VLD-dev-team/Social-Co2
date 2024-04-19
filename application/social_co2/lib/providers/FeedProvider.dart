import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/utils/requestsService.dart';

class FeedProvider extends ChangeNotifier {
  // Variables globales au provider
  List<SCO2Post> feed = [];
  Map<String, dynamic> postComments = {};
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

    newFeed.add(SCO2Post(
        postID: 0,
        postTextContent: "Salut tout le monde, J'ai fait du vélo ce matin !",
        userName: 'Valentin',
        userPhotoURL: 'url',
        userID: userID,
        postLinkedActivity: SCO2activity(
            activityName: "Activité",
            activityType: 'renovation',
            activityTimestamp: DateTime.now()),
        postCreatedAt: DateTime.now(),
        postType: "text"));

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
