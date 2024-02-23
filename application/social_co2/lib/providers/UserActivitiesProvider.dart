import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity/activity.dart';

class UserActivitiesProvider extends ChangeNotifier {
  List<SCO2activity> userActivities = [];
  bool isLoading = false;

  getUserActivities(index) async {
    isLoading = true;

    //userActivities.addAll();
  }
}
