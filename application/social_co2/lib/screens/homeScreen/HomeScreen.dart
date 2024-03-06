// Importation des packages requis pour flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importation des providers requis
import 'package:social_co2/providers/IndexProvider.dart';

// Importation des styles et du module responsive
import 'package:social_co2/styles/HomeScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

// Importation des widgets
import 'package:social_co2/screens/widgets/Feed.dart';
import 'package:social_co2/screens/widgets/LeaderBoard.dart';
import 'package:social_co2/screens/widgets/ReccurentActivities.dart';
import 'package:social_co2/screens/widgets/ScoreQuickOverview.dart';
import 'package:social_co2/screens/widgets/CallToPost.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: (responsiveFormat == ResponsiveFormats.large)
                    ? (MediaQuery.of(context).size.width - drawerWidth) / 3 * 2
                    : (MediaQuery.of(context).size.width -
                        drawerWidth), // On définie notre colonne de gauche comme faisait soit deux tiers de l'écran quand il est large ou comme 100% de l'espace d'écran si jamais il est plus petits
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      ScoreQuickOverview(),
                      // On intégre les widgets de droite en dessous du recap du score sur les plus petits écrans
                      (responsiveFormat == ResponsiveFormats.mid ||
                              responsiveFormat == ResponsiveFormats.small)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                LeaderBoard(),
                                ReccurentActivities()
                              ],
                            )
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      CallToPost(),
                      const Feed()
                    ]),
                  ),
                )),
            if (responsiveFormat ==
                ResponsiveFormats
                    .large) // On insére les widgets de la colonne de droite si l'écran est large
              SizedBox(
                  width: (MediaQuery.of(context).size.width - drawerWidth) / 3,
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                        LeaderBoard(),
                        ReccurentActivities(),
                      ]))),
          ],
        ));
  }
}
