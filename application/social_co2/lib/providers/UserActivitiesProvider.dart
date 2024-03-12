import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity/activity.dart';
import 'package:social_co2/main.dart';

class UserActivitiesProvider extends ChangeNotifier {
  List<SCO2activity> userActivities = [];

  bool isLoading = false;
  String error = "";

  Future<List<SCO2activity>> getCurrentUserActivities(int index) async {
    isLoading = true;
    final String? token = await firebaseAuth.currentUser?.getIdToken();
    final String? userID = firebaseAuth.currentUser?.uid;

    await Future.delayed(const Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
    return userActivities;
  }
}
