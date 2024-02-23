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
  /* @override
  void initState() {
    super.initState();
    final userActivitiesProvider =
        Provider.of<UserActivitiesProvider>(context, listen: false);
    userActivitiesProvider.getUserActivities();
  } */

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        IndexProvider();
      },
      builder: (context, child) {
        return const Text("data");
      },
    );
  }
}
