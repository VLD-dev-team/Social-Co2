import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/main.dart';
import 'package:social_co2/providers/FeedProvider.dart';
import 'package:social_co2/utils/requestsService.dart';

class MakePostProvider extends ChangeNotifier {
  bool posting = false;
  bool sended = false;
  String error = "";

  MakePostProvider() {
    resetSended();
  }

  Future<void> resetSended() async {
    sended = false;
    notifyListeners();
  }

  // Fonction pour poster un mood
  Future<SCO2Post> postMood(label) async {
    // Obtention le user id
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // Création d'un poste avec une instance de SCO2Post
    SCO2Post postData = SCO2Post(
        postID: 0,
        userID: userID,
        postCreatedAt: DateTime.now(),
        postType: "mood",
        moodLabel: '$label');

    // Envoie du post vers le serveur
    final postReq = await uploadPost(postData);
    return postReq;
  }

  // Fonction pour un post textuel
  Future<SCO2Post> postText(String textContent) async {
    // Obtention le user id
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // Création d'un poste avec une instance de SCO2Post
    SCO2Post postData = SCO2Post(
      postID: 0,
      userID: userID,
      postCreatedAt: DateTime.now(),
      postType: "message",
      postTextContent: textContent,
    );

    // Envoie du post vers le serveur
    final postReq = await uploadPost(postData);
    return postReq;
  }

  Future<SCO2Post> postActivity(SCO2activity activity) async {
    // Obtention le user id
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // Création d'un poste avec une instance de SCO2Post
    SCO2Post postData = SCO2Post(
      postID: 0,
      userID: userID,
      postCreatedAt: DateTime.now(),
      postType: "activite",
      postTextContent:
          "J'ai effectué(e) cet activité : ${activity.activityName}",
      postLinkedActivity: activity,
    );

    // Envoie du post vers le serveur
    final postReq = await uploadPost(postData);
    return postReq;
  }

  // Fonction d'envoi du post (tout type confondu)
  Future<SCO2Post> uploadPost(SCO2Post post) async {
    posting = true;
    sended = false;
    notifyListeners();

    // On récupère le token de connexion
    final authToken = await firebaseAuth.currentUser!.getIdToken();
    final userID = firebaseAuth.currentUser!.uid;

    // On construit le body de la requette
    var body = post.toJson();
    body.addAll({'activityid': post.postLinkedActivity!.activityID});

    // On fait la requette au server
    final data = await requestService().post(
      'social/posts/',
      {
        "authorization": '$authToken',
        'userid': '$userID',
      },
      body,
    );

    // On analyse la réponse du server
    // En cas d'erreur, on renvoie erreur aux widgets
    if (data["error"] == true) {
      try {
        error = 'error: ${data["error_message"].toString()}';
      } catch (e) {
        error = "error: unknown error";
      }
      posting = false;
      print(error);
      notifyListeners();
      return post;
    }

    // Si pas d'erreur  on met à jour le provider
    error = "";
    posting = false;
    sended = true;
    notifyListeners();
    return post;
  }
}
