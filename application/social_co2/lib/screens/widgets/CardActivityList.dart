import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class CardActivitiesList extends StatefulWidget {
  const CardActivitiesList({super.key});

  @override
  State<StatefulWidget> createState() => _CardActivityList();
}

class _CardActivityList extends State<CardActivitiesList> {
  DateTime _selectedDate = DateTime.now();

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
            ],
          )
        ],
      ),
    );
  }
}
