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
    userActivitiesProvider.getCurrentUserActivities(0);
  } */

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        IndexProvider();
        UserActivitiesProvider();
      },
      builder: (context, child) {
        return FutureBuilder(
          future: Provider.of<UserActivitiesProvider>(context, listen: false)
              .getCurrentUserActivities(0),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (var i = 0; i < snapshot.data!.length; i++) {
                
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          },
        );
      },
    );
  }
}
