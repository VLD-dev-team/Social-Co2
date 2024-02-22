// Importation des packages requis pour flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/IndexProvider.dart';
import 'package:social_co2/screens/widgets/Feed.dart';
import 'package:social_co2/screens/widgets/LeaderBoard.dart';
import 'package:social_co2/screens/widgets/ReccurentActivities.dart';
import 'package:social_co2/screens/widgets/ScoreQuickDash.dart';

// Importation des styles et du module responsive
import '../../styles/HomeScreenStyle.dart';
import '../../utils/responsiveHandler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Variables necessaires au responsive
    ResponsiveFormats responsiveFormat = whichResponsiveFormat(context);
    int drawerWidth = getDrawerWidth(context);

    return Container(
        width: MediaQuery.of(context).size.width -
            drawerWidth, // On défini la largeur du conteneur pour qu'il prenne tout l'espace à droite du drawer sur le web
        decoration: homeScreenBackground,
        child: Row(
          children: [
            SizedBox(
                width: (responsiveFormat == ResponsiveFormats.large)
                    ? (MediaQuery.of(context).size.width - drawerWidth) / 3 * 2
                    : (MediaQuery.of(context).size.width -
                        drawerWidth), // On définie notre colonne de gauche comme faisait soit deux tiers de l'écran quand il est large ou comme 100% de l'espace d'écran si jamais il est plus petits
                child: Column(children: [
                  const ScoreQuickDash(),
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
                  const Feed()
                ])),
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
