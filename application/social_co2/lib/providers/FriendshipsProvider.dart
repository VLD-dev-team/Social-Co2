import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/classes/SCO2user.dart';
import 'package:social_co2/utils/requestsService.dart';

class FriendshipsProvider extends ChangeNotifier {
  // Variables globale au provider
  bool loading = false;
  String error = "";
  // Stockage des listes d'utilisateurs
  List<SCO2user> friends = []; // Amis de l'utilisateur courant
  List<SCO2user> friendRequests = []; // Demandes d'amitiés entrantes
  List<SCO2user> pendingRequests = []; // Demandes d'amitiés sortantes
  List<SCO2user> blockedUsers = []; // bloqués par l'utilisateur courant

  FriendshipsProvider() {
    refreshData();
  }

  Future<void> refreshData() async {
    getFriends();
    getFriendRequests();
    getPendingRequests();
    getBlockedUsers();
  }

  Future<List<SCO2user>> getFriends() async {
    await getListOfUsers("friends")
        .then((value) => friends = value)
        .catchError((err) {
      error = err.toString();
      return Future(() => friends);
    });
    notifyListeners();
    return friends;
  }

  Future<List<SCO2user>> getFriendRequests() async {
    await getListOfUsers("request_receive")
        .then((value) => friendRequests = value)
        .catchError((err) {
      error = err.toString();
      return Future(() => friendRequests);
    });
    notifyListeners();
    return friendRequests;
  }

  Future<List<SCO2user>> getPendingRequests() async {
    await getListOfUsers("request_send")
        .then((value) => pendingRequests = value)
        .catchError((err) {
      error = err.toString();
      return Future(() => pendingRequests);
    });
    notifyListeners();
    return pendingRequests;
  }

  Future<List<SCO2user>> getBlockedUsers() async {
    await getListOfUsers("block")
        .then((value) => blockedUsers = value)
        .catchError((err) {
      error = err.toString();
      return Future(() => blockedUsers);
    });
    notifyListeners();
    return blockedUsers;
  }

  Future<List<SCO2user>> getListOfUsers(String actionType) async {
    // On initialise la liste et le provider
    error = "";
    loading = true;
    notifyListeners();
    List<SCO2user> list = [];

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final userID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().get("friends?actionType=$actionType", {
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
      return list;
    }

    // On transforme les données en liste d'utilisateur SCO2
    if (data['results'] != []) {
      for (var i = 0; i < data['results'].length; i++) {
        final userData = SCO2user.fromJSON(data['results'][i]);
        list.add(userData);
      }
    }

    // On termine la requette
    loading = false;
    notifyListeners();
    return list;
  }

  Future<String> sendFriendRequest(String userID) async {
    var status = "";
    await requestAction("add", userID)
        .then((value) => status = value)
        .catchError((err) => error = err);
    return status;
  }

  Future<String> blockUser(String userID) async {
    var status = "";
    await requestAction("block", userID)
        .then((value) => status = value)
        .catchError((err) => error = err);
    return status;
  }

  Future<String> unlockUser(String userID) async {
    var status = "";
    await requestAction("deblock", userID)
        .then((value) => status = value)
        .catchError((err) => error = err);
    return status;
  }

  Future<String> acceptFriendRequest(String userID) async {
    var status = "";
    await requestAction("accept", userID)
        .then((value) => status = value)
        .catchError((err) => error = err);
    return status;
  }

  Future<String> refuseFriendRequest(String userID) async {
    var status = "";
    await requestAction("refuse", userID)
        .then((value) => status = value)
        .catchError((err) => error = err);
    return status;
  }

  Future<String> deleteFriend(String userID) async {
    var status = "";
    await requestAction("delete", userID)
        .then((value) => status = value)
        .catchError((err) => error = err);
    return status;
  }

  Future<String> undoPendingRequest(String userID) async {
    var status = "";
    await requestAction("undo", userID)
        .then((value) => status = value)
        .catchError((err) => error = err);
    return status;
  }

  Future<String> requestAction(actionType, userID) async {
    // On initialise la liste et le provider
    error = "";
    loading = true;
    notifyListeners();

    // On récupère le token de connexion
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final myuserID = FirebaseAuth.instance.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().post(
      "friends",
      {
        "authorization": '$authToken',
        'userid': myuserID,
      },
      {
        "actionType": actionType.toString(),
        "friendid": userID.toString(),
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
      return "";
    }

    // On obtient le message du serveur
    final message = '${data['message']}';
    
    // On obtient de nouveau la liste des relations
    refreshData();

    // On termine la requette
    return message;
  }
}
