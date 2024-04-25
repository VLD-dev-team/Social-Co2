import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/classes/activity.dart';
import 'package:social_co2/providers/MakePostProvider.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/screens/widgets/ActivitiesList.dart';
import 'package:social_co2/styles/CardStyles.dart';

class dialogPostActivities extends StatefulWidget {
  const dialogPostActivities({super.key});

  @override
  State<dialogPostActivities> createState() => _dialogPostActivitiesState();
}

class _dialogPostActivitiesState extends State<dialogPostActivities> {
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<SCO2activity> activityListForSelectedDate = [];

  @override
  Widget build(BuildContext context) {
    // controller de la date courante
    return ChangeNotifierProvider(
        create: (_) => MakePostProvider(),
        builder: (context, child) =>
            Consumer<MakePostProvider>(builder: ((context, value, child) {
              return AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: secondaryCardColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChangeNotifierProvider(
                      create: (_) => UserActivitiesProvider(),
                      builder: (context, child) => IconButton(
                        icon: const Icon(Icons.calendar_month),
                        disabledColor: Colors.transparent,
                        onPressed: () => showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: (FirebaseAuth.instance.currentUser!
                                            .metadata.creationTime ==
                                        null)
                                    ? DateTime(2024)
                                    : FirebaseAuth.instance.currentUser!
                                        .metadata.creationTime!,
                                lastDate: DateTime.now())
                            .then(
                          (value) {
                            if (value != null) {
                              setState(() {
                                selectedDate = value;
                              });
                              Provider.of<UserActivitiesProvider>(context,
                                      listen: false)
                                  .getCurrentUserActivitiesByDate(selectedDate)
                                  .then((value) => setState(() {
                                        activityListForSelectedDate = value;
                                      }));
                            }
                          },
                        ),
                      ),
                    ),
                    Center(
                        child: Container(
                            decoration: primaryCard,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Text(
                                'Poster une activité',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ))),
                    IconButton(
                        onPressed: (value.posting)
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        icon: const Icon(Icons.close)),
                  ],
                ),
                content: SizedBox(
                  height: 400,
                  width: 600,
                  child: (value.posting)
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        )
                      : (value.error == "")
                          ? ChangeNotifierProvider(
                              create: (_) => UserActivitiesProvider(),
                              builder: (context, child) =>
                                  Consumer<UserActivitiesProvider>(
                                      builder: (context, value2, child) {
                                    if (value2.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.black),
                                      );
                                    } else if (value2.error != "") {
                                      return Center(
                                        child: Text("Erreur: ${value2.error}"),
                                      );
                                    } else {
                                      return ActivitiesList(
                                          activities:
                                              (activityListForSelectedDate
                                                      .isEmpty)
                                                  ? value2.userActivitiesPerDays[
                                                      selectedDate]
                                                  : activityListForSelectedDate,
                                          selection: true,
                                          error: value2.error);
                                    }
                                  }))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                const Text(
                                  "Erreur lors du post de votre activité",
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  value.error,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                ),
              );
            })));
  }
}
