import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_co2/classes/leaderboard.dart';
import 'package:social_co2/utils/requestsService.dart';

class LeaderBoardProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = "";
  LeaderBoard leaderBoardWorld =
      LeaderBoard(leaderBoardType: "world", leaderBoardData: []);
  LeaderBoard leaderBoardFriends =
      LeaderBoard(leaderBoardType: "friends", leaderBoardData: []);

  LeaderBoardProvider() {
    initData();
  }

  Future<void> initData() async {
    getLeaderBoard('world');
    getLeaderBoard('friend');
  }

  Future<LeaderBoard> getLeaderBoard(String leaderBoardType) async {
    isLoading = true;
    notifyListeners();

    // Obtention du token et du UserID
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();

    // On fait la requete au serveur
    final endpoint = (leaderBoardType == "world")
        ? "leaderboard/world"
        : "leaderboard/friends";
    final data = await requestService().get(endpoint, {
      "authorization": '$token',
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
      isLoading = false;

      notifyListeners();
      return (leaderBoardType == "world")
          ? leaderBoardWorld
          : leaderBoardFriends;
    }

    try {
      if (leaderBoardType == "world") {
        leaderBoardWorld = LeaderBoard.fromJSON(data);
      } else {
        leaderBoardFriends = LeaderBoard.fromJSON(data);
      }
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return (leaderBoardType == "world")
          ? leaderBoardWorld
          : leaderBoardFriends;
    }

    error = "";
    isLoading = false;
    notifyListeners();
    return (leaderBoardType == "world") ? leaderBoardWorld : leaderBoardFriends;
  }
}
