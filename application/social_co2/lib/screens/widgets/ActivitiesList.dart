import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/collections/activitiesData.dart';
import 'package:social_co2/providers/MakePostProvider.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class ActivitiesList extends StatelessWidget {
  bool selection = false;
  List<SCO2activity>? activities = [];
  String error = "";
  String? action;

  ActivitiesList({
    super.key,
    required this.activities,
    required this.selection,
    required this.error,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    activities ??= []; // Si activities est null, alors on crée une liste vide

    if (activities!.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline),
          SizedBox(height: 5),
          Text("Aucun élément enregistré pour cette journée.")
        ],
      );
    } else if (error != "") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          const Text(
            "Erreur lors de l'obtention des données",
            style: TextStyle(color: Colors.red),
          ),
          Text(
            error,
            style: const TextStyle(color: Colors.red),
          )
        ],
      );
    } else {
      return ListView.separated(
          itemCount: activities!.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 5);
          },
          itemBuilder: (context, index) {
            SCO2activity activity = activities![index];

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
                    ? "Repas"
                    : meals[meals.indexWhere((element) =>
                        element['type'] ==
                        activity.activityMealIngredients)]['label'];
                break;
              case "purchase":
                details = (purchases.indexWhere((element) =>
                            element['type'] == activity.activityPurchase) ==
                        -1)
                    ? "Achat"
                    : purchases[purchases.indexWhere((element) =>
                        element['type'] == activity.activityPurchase)]['label'];
                break;
              case "build":
                details = (builds.indexWhere((element) =>
                            element['type'] == activity.activityBuild) ==
                        -1)
                    ? "Bricolage"
                    : builds[builds.indexWhere((element) =>
                        element['type'] == activity.activityBuild)]['label'];
                break;
              case "route":
                final distance = activity.activityDistance;
                final vehicule = (availableVehicles.indexWhere((element) =>
                            element['type'] == activity.activityVehicule) ==
                        -1)
                    ? "Trajet"
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
              case "mail":
                details = "Moins d'espace utilisé sur vos espaces en ligne !";
                break;
              default:
            }

            return Container(
              decoration: primaryCard,
              child: ListTile(
                onTap: (selection)
                    ? () {
                        switch (action) {
                          case "post":
                            Provider.of<MakePostProvider>(context,
                                    listen: false)
                                .postActivity(activities![index]);
                            break;
                          case "add":
                            break;
                        }
                      }
                    : null,
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${activity.activityCO2Impact}'),
                    if (selection)
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.send,
                          color: Colors.black,
                        ),
                      )
                  ],
                ),
              ),
            );
          });
    }
  }
}
