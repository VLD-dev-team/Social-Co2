class LeaderBoard {
  String? leaderBoardType;
  List<dynamic> leaderBoardData;

  LeaderBoard({
    this.leaderBoardType,
    required this.leaderBoardData,
  });

  factory LeaderBoard.fromJSON(Map<String, dynamic> json) {
    return LeaderBoard(
      leaderBoardData: json["leaderboard"],
    );
  }
}
