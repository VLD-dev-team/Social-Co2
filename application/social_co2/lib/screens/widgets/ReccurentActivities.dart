import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/ReccurentActivitiesProvider.dart';
import 'package:social_co2/screens/widgets/ActivitiesList.dart';
import 'package:social_co2/styles/CardStyles.dart';

class ReccurentActivities extends StatelessWidget {
  const ReccurentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height - 630,
      decoration: primaryCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            //widget qui permet d'adapter la taille
            width: 300, //largeur de la sizedbox
            child: Card(
              //Widget Card dans le widget SizedBox qui contiendra le titre
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Center(
                  child: Text(
                    "Activités récurrentes", //titre
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
          Consumer<ReccurentActivitiesProvider>(
            builder: ((context, PROVIDERVALUES, child) {
              if (PROVIDERVALUES.isLoading) {
                //si les données sont en chargement
                return const SizedBox(
                  height: 40,
                  //on affiche l'icone de chargement
                  child: LinearProgressIndicator(),
                );
              } else {
                if (PROVIDERVALUES.error == "") {
                  //on affiche la liste
                  return SizedBox(
                    height: 120,
                    child: ActivitiesList(
                      activities: PROVIDERVALUES.reccurentActivities,
                      selection: false,
                      error: PROVIDERVALUES.error,
                    ),
                  );
                } else {
                  //on affiche l'erreur
                  return SizedBox(
                    child: Text(PROVIDERVALUES.error),
                  );
                }
              }
            }),
          ),
        ],
      ),
    );
  }
}
