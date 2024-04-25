import 'package:flutter/material.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/collections/activitiesData.dart';
import 'package:social_co2/styles/CardStyles.dart';

class FeedPost extends StatelessWidget {
  final SCO2Post postData;

  const FeedPost({
    super.key,
    required this.postData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: primaryCard,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  radius: 360,
                  backgroundImage: (postData.userPhotoURL == null)
                      ? null
                      : NetworkImage('${postData.userPhotoURL}'),
                  backgroundColor: Colors.green,
                  child: (postData.userPhotoURL == null)
                      ? const Icon(Icons.account_box)
                      : null,
                ),
              ),
              title: Text('${postData.userName}'),
              subtitle: Text(postData.postCreatedAt.toIso8601String())),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              '${postData.postTextContent}',
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          if (postData.postLinkedActivity != null) activityShowcase(),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 15),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  label: Text("25"),
                  icon: Icon(Icons.favorite),
                ),
                TextButton.icon(
                  onPressed: () {},
                  label: Text("2"),
                  icon: Icon(Icons.comment),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget activityShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Text(
            "ACTIVITÉ LIÉ AU POST",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          color: secondaryCardColor,
          child: Builder(builder: (context) {
            SCO2activity activity = postData.postLinkedActivity!;

            Icon icon = (activeActivityTypes.indexWhere((element) =>
                        element['type'] == activity.activityType) ==
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
                        element['type'] ==
                        activity.activityMealIngredients)]['label'];
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
                final distance = activity.activityDistance;
                final vehicule = (availableVehicles.indexWhere((element) =>
                            element['type'] == activity.activityVehicule) ==
                        -1)
                    ? ""
                    : availableVehicles[availableVehicles.indexWhere(
                            (element) =>
                                element['type'] == activity.activityVehicule)]
                        ['label'];
                details = '${distance}km - $vehicule';
                if (availableVehicles.indexWhere((element) =>
                        element['type'] == activity.activityVehicule) !=
                    -1) {
                  icon = availableVehicles[availableVehicles.indexWhere(
                          (element) =>
                              element['type'] == activity.activityVehicule)]
                      ['icon'];
                }
                break;
              case "cleanInbox":
                details = "Moins d'espace utilisé sur les espaces en ligne !";
                break;
              default:
            }

            return ListTile(
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
              subtitle: Text(details),
            );
          }),
        ),
      ],
    );
  }
}
