import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/main.dart';
import 'package:social_co2/providers/IndexProvider.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';

class ScoreQuickOverview extends StatefulWidget {
  @override
  State<ScoreQuickOverview> createState() => _ScoreQuickOverviewState();
}

class _ScoreQuickOverviewState extends State<ScoreQuickOverview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Provider.of<UserActivitiesProvider>(context, listen: false)
            .userActivities[0]
            .activityName),
        Text(Provider.of<UserActivitiesProvider>(context, listen: false)
            .userActivities[1]
            .activityName),
        Text(Provider.of<IndexProvider>(context, listen: false)
            .selectedIndex
            .toString()),
        Text(Provider.of<UserActivitiesProvider>(context, listen: false)
            .userActivities
            .length
            .toString()),
        Text(Provider.of<UserActivitiesProvider>(context, listen: false)
            .userActivities[0]
            .activityName)
      ],
    );
  }
}
