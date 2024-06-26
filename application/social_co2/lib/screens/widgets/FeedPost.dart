import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/collections/activitiesData.dart';
import 'package:social_co2/screens/dialogs/dialogComments.dart';
import 'package:social_co2/providers/FeedProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class FeedPost extends StatefulWidget {
  final SCO2Post postData;

  const FeedPost({
    super.key,
    required this.postData,
  });

  @override
  State<StatefulWidget> createState() => _FeedPostState(postData: postData);
}

class _FeedPostState extends State<FeedPost> {
  final SCO2Post postData;

  _FeedPostState({
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
                  onPressed: () {
                    Provider.of<FeedProvider>(context, listen: false)
                        .likePost(postData.postID);
                  },
                  label: Text("${postData.postLikesNumber}"),
                  icon: (postData.liked == true)
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_outline_outlined),
                ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => dialogComments(
                        postData: postData,
                      ),
                    );
                  },
                  label: Text("${postData.postCommentsNumber}"),
                  icon: const Icon(Icons.comment),
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
