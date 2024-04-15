class SCO2Post {
  final int postID;
  final String userID;
  String? postTextContent;
  String? postMediaContentURL;
  int? postLinkedActivity;
  int? postLikesNumber;
  DateTime postCreatedAt;
  int? postCommentNumber;
  String postType;

  SCO2Post({
    required this.postID,
    required this.userID,
    required this.postCreatedAt,
    required this.postType,
    this.postTextContent,
    this.postMediaContentURL,
    this.postLinkedActivity,
    this.postLikesNumber,
    this.postCommentNumber,
  });

  factory SCO2Post.fromJSON(Map<String, dynamic> json) {
    return SCO2Post(
      postID: json["postID"],
      userID: json["userID"],
      postTextContent: json["postTextContent"],
      postMediaContentURL: json["postMediaContentURL"],
      postLinkedActivity: json["postLinkedActivity"],
      postLikesNumber: json["postLikesNumber"],
      postCreatedAt: DateTime.parse(json["postCreatedAt"]),
      postCommentNumber: json["postCommentNumber"],
      postType: json["postType"],
    );
  }

  Map<String, String> toJson() {
    final Map<String, String> data = {
      'postID': postID.toString(),
      'userID': userID,
      'postCreatedAt': postCreatedAt.toIso8601String(),
      'postType': postType,
    };

    if (postTextContent != null) {
      data['postTextContent'] = postTextContent!.toString();
    }

    if (postMediaContentURL != null) {
      data['postMediaContentURL'] = postMediaContentURL!.toString();
    }

    if (postLinkedActivity != null) {
      data['postLinkedActivity'] = postLinkedActivity!.toString();
    }

    if (postLikesNumber != null) {
      data['postLikesNumber'] = postLikesNumber!.toString();
    }

    if (postCommentNumber != null) {
      data['postCommentNumber'] = postCommentNumber!.toString();
    }

    return data;
  }
}
