import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/classes/activity/activity.dart';
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
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.car_crash),
                  )
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
