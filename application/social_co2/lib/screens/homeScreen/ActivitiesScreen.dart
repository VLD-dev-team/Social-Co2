// Importation des packages requis pour flutter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importation des providers requis
import 'package:social_co2/providers/IndexProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

// Importation des styles et du module responsive
import 'package:provider/provider.dart';
import 'package:social_co2/styles/MainScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityScreen();
}

class _ActivityScreen extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    // Variables necessaires au responsive
    ResponsiveFormats responsiveFormat = whichResponsiveFormat(context);
    int drawerWidth = getDrawerWidth(context);

    return Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width -
            drawerWidth, // On défini la largeur du conteneur pour qu'il prenne tout l'espace à droite du drawer sur le web
        decoration: homeScreenBackground,
        child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 20, right: 20),
                  decoration: primaryCard,
                  height: 40,
                  child: TabBar(
                      labelColor: Colors.black,
                      labelStyle: GoogleFonts.readexPro(),
                      indicatorColor: Colors.black,
                      indicatorWeight: 2.0,
                      tabs: const <Widget>[
                        Tab(
                          text: "Activités journalières",
                        ),
                        Tab(
                          text: "Informations complémentaires",
                        )
                      ]),
                ),
                const Expanded(
                    child: TabBarView(children: [
                  CardActivitiesList(),
                  CardMoreInformations()
                ]))
              ],
            )));
  }
}

class CardMoreInformations extends StatelessWidget {
  const CardMoreInformations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text("data2");
  }
}

class CardActivitiesList extends StatelessWidget {
  const CardActivitiesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: primaryCard,
      child: Row(),
    );
  }
}
