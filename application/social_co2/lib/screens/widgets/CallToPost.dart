import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/FeedProvider.dart';
import 'package:social_co2/providers/MakePostProvider.dart';
import 'package:social_co2/screens/dialogs/dialogMood.dart';
import 'package:social_co2/screens/dialogs/dialogPostActivities.dart';
import 'package:social_co2/styles/CardStyles.dart';

class CallToPost extends StatelessWidget {
  CallToPost({super.key});

  final Widget userphoto = (FirebaseAuth.instance.currentUser!.photoURL != null)
      ? Container(
          child: SizedBox(
            width: 45,
            height: 45,
            child: CircleAvatar(
              radius: 360,
              backgroundImage: NetworkImage(
                  '${FirebaseAuth.instance.currentUser!.photoURL}'),
            ),
          ),
        )
      : const Icon(
          Icons.account_circle_outlined,
          size: 45,
        );

  @override
  Widget build(BuildContext context) {
    final postFieldController = TextEditingController();

    return Container(
      decoration: primaryCard,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: secondaryCardColor,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userphoto,
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: primaryCardColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                                hintText: "Quoi de neuf..."),
                            controller: postFieldController,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              color: secondaryCardColor,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  spacing: 10,
                  children: [
                    FilledButton.icon(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const MoodDialog();
                              }).then((value) => Provider.of<FeedProvider>(
                                  context,
                                  listen: false)
                              .refreshFeed());
                        },
                        icon: const Icon(Icons.mood),
                        label: const Text("Ton humeur")),
                    FilledButton.icon(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const dialogPostActivities();
                              }).then((value) => Provider.of<FeedProvider>(
                                  context,
                                  listen: false)
                              .refreshFeed());
                        },
                        icon: const Icon(Icons.energy_savings_leaf_outlined),
                        label: const Text("Poste tes activités")),
                    FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.upload),
                        label: const Text("Ton rapport")),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
