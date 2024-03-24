import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/classes/activity/activity.dart';
import 'package:social_co2/collections/activitiesData.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class ActivitiesList extends StatelessWidget {
  bool multiSelection = false;
  List<SCO2activity> activities = [];

  ActivitiesList({
    super.key,
    required this.activities,
    required this.multiSelection,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: activities.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 5);
        },
        itemBuilder: (context, index) {
          SCO2activity activity = activities[index];

          Icon icon = (activeActivityTypes.indexWhere(
                      (element) => element['type'] == activity.activityType) ==
                  -1)
              ? const Icon(Icons.category, color: Colors.black)
              : activeActivityTypes[activeActivityTypes.indexWhere(
                      (element) => element['type'] == activity.activityType)]
                  ['icon'];

          String details = "";
          switch (activity.activityType) {
            case "meal":
              details = (meals.indexWhere((element) =>
                          element['type'] ==
                          activity.activityMealIngredients) ==
                      -1)
                  ? ""
                  : meals[meals.indexWhere((element) =>
                          element['type'] == activity.activityMealIngredients)]
                      ['label'];
              break;
            case "purchase":
              details = (purchases.indexWhere((element) =>
                          element['type'] == activity.activityPurchase) ==
                      -1)
                  ? ""
                  : purchases[purchases.indexWhere((element) =>
                      element['type'] == activity.activityPurchase)]['label'];
              break;
            case "build":
              details = (builds.indexWhere((element) =>
                          element['type'] == activity.activityBuild) ==
                      -1)
                  ? ""
                  : builds[builds.indexWhere((element) =>
                      element['type'] == activity.activityBuild)]['label'];
              break;
            case "route":
              break;
            case "cleanInbox":
              break;
            default:
          }

          return Container(
            decoration: primaryCard,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      '${activity.activityTimestamp.hour}:${activity.activityTimestamp.minute}'),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: const Color.fromRGBO(157, 188, 152, 1),
                    child: icon,
                  ),
                ],
              ),
              title: Text(activity.activityName),
              subtitle: Text(activity.activityType),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${activity.activityCO2Impact}'),
                  if (multiSelection)
                    Checkbox(
                      value: false,
                      onChanged: (value) => {value == true},
                    )
                ],
              ),
            ),
          );
        });
  }
}
