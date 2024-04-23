import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/screens/dialogs/dialogNewActivity.dart';
import 'package:social_co2/screens/widgets/ActivitiesList.dart';
import 'package:social_co2/styles/CardStyles.dart';

class CardActivitiesList extends StatefulWidget {
  const CardActivitiesList({super.key});

  @override
  State<StatefulWidget> createState() => _CardActivityList();
}

class _CardActivityList extends State<CardActivitiesList> {
  // controller de la date courante
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: primaryCard,
      child: Column(
        children: [
          Row(
            children: [
              const Card(
                margin: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Center(
                    child: Text(
                      "Activités",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: (FirebaseAuth.instance.currentUser!
                                      .metadata.creationTime ==
                                  null)
                              ? DateTime(2024)
                              : FirebaseAuth
                                  .instance.currentUser!.metadata.creationTime!,
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now())
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        _selectedDate = value;
                        Provider.of<UserActivitiesProvider>(context,
                                listen: false)
                            .getCurrentUserActivitiesByDate(_selectedDate);
                      });
                    }
                  });
                },
                child: Card(
                  margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          ('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}' !=
                                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}')
                              ? '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'
                              : "Aujourd'hui",
                          style: const TextStyle(fontSize: 25),
                        ),
                        const Icon(
                          Icons.expand_more_rounded,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Consumer<UserActivitiesProvider>(
                  builder: (context, value, child) {
                if (value.isLoading) {
                  return Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 20,
                      height: 20,
                      child:
                          const CircularProgressIndicator(color: Colors.black));
                } else {
                  return const SizedBox(
                    width: 0,
                    height: 0,
                  );
                }
              })
            ],
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.only(
                  top: 5, bottom: 15, left: 10, right: 10),
              decoration: secondaryCardInnerShadow,
              child: ActivitiesList(
                multiSelection: false,
                activities: Provider.of<UserActivitiesProvider>(context,
                            listen: true)
                        .userActivitiesPerDays[
                    _selectedDate], // Activités à afficher pour le jour selectionné
                error:
                    Provider.of<UserActivitiesProvider>(context, listen: true)
                        .error,
              ),
            ),
          ),
          FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const newActivityDialog();
                  }).then((value) => Provider.of<UserActivitiesProvider>(
                      context,
                      listen: false)
                  .initData());
            },
            label: const Text(
              "Ajouter une activité",
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
