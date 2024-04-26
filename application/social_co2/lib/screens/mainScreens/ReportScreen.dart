import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/SCO2ReportProvider.dart';
import 'package:social_co2/screens/widgets/ActivitiesList.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/styles/MainScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    int drawerWidth = getDrawerWidth(context);

    return Consumer<SCO2ReportProvider>(
      builder: (context, PROVIDERVALUES, child) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width -
              drawerWidth, // On défini la largeur du conteneur pour qu'il prenne tout l'espace à droite du drawer sur le web
          decoration: homeScreenBackground,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    height: MediaQuery.of(context).size.height,
                    width: 400,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Votre rapport',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          const Text(
                            'RECAP DES 7 DERNIERS JOURS',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            'Impact maximum ces derniers jours :',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${PROVIDERVALUES.activityMaxImpactScore}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 50),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    if (PROVIDERVALUES.isLoading) {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: Colors.white));
                    } else if (PROVIDERVALUES.report.isEmpty) {
                      return const Center(
                        child: Text('Pas de données à afficher',
                            style: TextStyle(color: Colors.white)),
                      );
                    } else if (PROVIDERVALUES.error != "") {
                      return Center(
                        child: Text('Erreur: ${PROVIDERVALUES.error}',
                            style: const TextStyle(color: Colors.white)),
                      );
                    } else {
                      List<Widget> dayslist = [];
                      for (var i = 0; i < PROVIDERVALUES.report.length; i++) {
                        var dateData = PROVIDERVALUES.report[i];
                        dayslist.add(dayCard(dateData));
                      }
                      return Row(children: dayslist);
                    }
                  })
                ],
              ),
            ),
          )),
    );
  }

  Widget dayCard(Map<String, dynamic> dateData) {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
      height: MediaQuery.of(context).size.height,
      width: 600,
      decoration: primaryCard,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  "${dateData['day']}",
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Text("IMPACT CE JOUR"),
                    Text(
                      "${dateData['impact']}",
                      style: TextStyle(fontSize: 50),
                    ),
                    SizedBox(height: 20),
                    Text("ACTIVITÉS"),
                  ],
                )),
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 5, right: 5),
                decoration: secondaryCardInnerShadow,
                child: ActivitiesList(
                  selection: false,
                  activities: dateData[
                      'activities'], // Activités à afficher pour le jour selectionné
                  error: "",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
