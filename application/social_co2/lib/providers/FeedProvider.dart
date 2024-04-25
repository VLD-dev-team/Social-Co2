import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/utils/requestsService.dart';

class FeedProvider extends ChangeNotifier {
  // Variables globales au provider
  List<SCO2Post> feed = [];
  Map<int, dynamic> postComments = {};
  String error = "";
  bool loading = false;
  bool gettingNewComments = false;
  bool postingComment = false;

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
    feed.clear();

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
      return feed;
    }

    // On transforme les données en liste de post SCO2
    if (data['feed'] != []) {
      for (var i = 0; i < data['feed'].length; i++) {
        final post =
            SCO2Post.fromJSON(Map<String, dynamic>.from(data["feed"][i]));
        feed.add(post);
      }
    }

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
    final data = await requestService().post(
      "social/like",
      {
        "authorization": '$authToken',
        'userid': userID,
      },
      {
        "postid": postID.toString(),
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

      loading = false;
      notifyListeners();
      return 0;
    }

    // On analyse les données renvoyés par le serveur et on affiche le like
    // Si le post est liké alors termine la fonction et on actualise le feed
    loading = false;
    final index = feed.indexWhere((element) => element.postID == postID);
    if (feed[index].liked!) {
      feed[index].postLikesNumber = feed[index].postLikesNumber! - 1;
      feed[index].liked = false;
    } else {
      feed[index].postLikesNumber = feed[index].postLikesNumber! + 1;
      feed[index].liked = true;
    }
    notifyListeners();
    return 0;
  }

  Future<dynamic> getPostComment(postID) async {
    error = "";
    gettingNewComments = true;
    notifyListeners();

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().get("social/comments?postid=$postID", {
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

      gettingNewComments = false;
      notifyListeners();
      return [];
    }

    // On ajoute les commentaires à la liste
    postComments.update(postID, (value) => data['comments'],
        ifAbsent: () => data['comments']);

    // On actualise les widgets et on renvoies les données
    gettingNewComments = false;
    notifyListeners();
    return postComments[postID];
  }

  Future<String> sendComment(postID, String commentTextContent) async {
    error = "";
    postingComment = true;
    notifyListeners();

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().post("social/comments", {
      "authorization": '$authToken',
      'userid': userID,
    }, {
      "postid": postID,
      "commentTextContent": commentTextContent.toString(),
    });

    // On analyse la réponse du server
    // En cas d'erreur, on renvoie erreur aux widgets
    if (data["error"] == true) {
      try {
        error = 'error: ${data["error_message"].toString()}';
      } catch (e) {
        error = "error: unknown error";
      }

      print(error);
      postingComment = false;
      notifyListeners();
      return error;
    }

    print(data);

    // On met à jour la liste des commentaires
    getPostComment(postID);

    // On actualise les widgets
    postingComment = false;
    notifyListeners();
    return "Commentaire posté";
  }
}
