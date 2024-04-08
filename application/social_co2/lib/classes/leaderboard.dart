class LeaderBoard {
  String leaderBoardType;
  List<Map<String, dynamic>> leaderBoardData;

  LeaderBoard({
    required this.leaderBoardType,
    required this.leaderBoardData,
  });

  factory LeaderBoard.fromJSON(Map<String, dynamic> json) {
    return LeaderBoard(
      leaderBoardType: json["leaderBoardType"], 
      leaderBoardData: json["leaderBoardData"],
    );
  }
}
