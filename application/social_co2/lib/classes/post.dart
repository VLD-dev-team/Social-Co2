import 'dart:convert';

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
  int? postCommentsNumber;
  String postType;
  String? moodLabel;
  bool? liked = false;

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
    this.postCommentsNumber,
    this.moodLabel,
    this.liked,
  });

  factory SCO2Post.fromJSON(Map<String, dynamic> json) {
    return SCO2Post(
      postID: json["postID"],
      userID: json["uid"],
      userName: json["name"],
      userPhotoURL: json["photoURL"],
      postTextContent: json["postTextContent"],
      postMediaContentURL: json["postMediaContentURL"],
      postLinkedActivity: (json["postLinkedActivity"] == "null")
          ? SCO2activity.fromJSON(json["postLinkedActivity"])
          : null,
      postLikesNumber: json["postLikesNumber"],
      postCreatedAt: DateTime.parse(json["postCreatedAt"]),
      postCommentsNumber: json["postCommentsNumber"],
      postType: json["postType"],
      moodLabel: json["mood"],
      liked: (json["like"] == "null") ? false : json["like"],
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

    if (postCommentsNumber != null) {
      data['postCommentsNumber'] = postCommentsNumber!;
    }

    if (moodLabel != null) {
      data['mood'] = moodLabel!;
    }

    if (liked != null) {
      data['like'] = liked!;
    }

    return data;
  }
}
