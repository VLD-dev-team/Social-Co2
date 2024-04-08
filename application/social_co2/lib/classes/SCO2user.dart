class SCO2user {
  final String userID;
  String? displayName;
  String? avatarURL;

  SCO2user({
    required this.userID,
    this.displayName,
    this.avatarURL,
  });

  factory SCO2user.fromJSON(Map<String, dynamic> json) {
    return SCO2user(
      userID: json["uid"],
      displayName: json['displayName'],
      avatarURL: json['avatarURL'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'uid': userID};

    if (displayName != null) {
      data['displayName'] = displayName!.toString();
    }

    if (avatarURL != null) {
      data['avatarURL'] = avatarURL!.toString();
    }

    return data;
  }
}
