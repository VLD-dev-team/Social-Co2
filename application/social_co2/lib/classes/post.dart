import 'package:social_co2/classes/activity.dart';

class SCO2Post {
  final int postID;
  final String userID;
  String? userName;
  String? userPhotoURL;
  String? postTextContent;
  String? postMediaContentURL;
  SCO2activity? postLinkedActivity;
  int? postLikesNumber;
  DateTime postCreatedAt;
  int? postCommentNumber;
  String postType;
  String? moodLabel;

  SCO2Post({
    required this.postID,
    required this.userID,
    required this.postCreatedAt,
    required this.postType,
    this.userName,
    this.userPhotoURL,
    this.postTextContent,
    this.postMediaContentURL,
    this.postLinkedActivity,
    this.postLikesNumber,
    this.postCommentNumber,
    this.moodLabel,
  });

  factory SCO2Post.fromJSON(Map<String, dynamic> json) {
    return SCO2Post(
      postID: json["postID"],
      userID: json["userID"],
      userName: json["userName"],
      userPhotoURL: json["userPhotoURL"],
      postTextContent: json["postTextContent"],
      postMediaContentURL: json["postMediaContentURL"],
      postLinkedActivity: SCO2activity.fromJSON(json["postLinkedActivity"]),
      postLikesNumber: json["postLikesNumber"],
      postCreatedAt: DateTime.parse(json["postCreatedAt"]),
      postCommentNumber: json["postCommentNumber"],
      postType: json["postType"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'postID': postID,
      'userID': userID,
      'postCreatedAt': postCreatedAt.toIso8601String(),
      'postType': postType,
    };

    if (userName != null) {
      data['userName'] = userName!;
    }

    if (userPhotoURL != null) {
      data['userPhotoURL'] = userPhotoURL!;
    }

    if (postTextContent != null) {
      data['postTextContent'] = postTextContent!.toString();
    }

    if (postMediaContentURL != null) {
      data['postMediaContentURL'] = postMediaContentURL!;
    }

    if (postLinkedActivity != null) {
      data['postLinkedActivity'] = postLinkedActivity!.toJson();
    }

    if (postLikesNumber != null) {
      data['postLikesNumber'] = postLikesNumber!;
    }

    if (postCommentNumber != null) {
      data['postCommentNumber'] = postCommentNumber!;
    }

    if (moodLabel != null) {
      data['mood'] = moodLabel;
    }

    return data;
  }
}
