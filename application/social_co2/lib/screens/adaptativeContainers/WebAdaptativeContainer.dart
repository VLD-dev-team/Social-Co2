// Importation des packages requis pour flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importation des écrans
import 'package:social_co2/screens/mainScreens/ActivitiesScreen.dart';
import 'package:social_co2/screens/mainScreens/HomeScreen.dart';
import 'package:social_co2/screens/mainScreens/LeaderBoardScreen.dart';
import 'package:social_co2/screens/mainScreens/MessagesScreen.dart';
import 'package:social_co2/screens/mainScreens/ReportScreen.dart';
import 'package:social_co2/screens/mainScreens/SearchScreen.dart';
import 'package:social_co2/screens/mainScreens/SettingsScreen.dart';

// Importation des styles et des providers pour le menu/drawer
import 'package:social_co2/styles/webDrawersStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

// Importation des providers
import 'package:social_co2/providers/IndexProvider.dart';

class WebAdaptativeContainer extends StatefulWidget {
  @override
  State<WebAdaptativeContainer> createState() => _WebAdaptativeContainerState();
}

class _WebAdaptativeContainerState extends State<WebAdaptativeContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveFormats responsiveFormat = whichResponsiveFormat(context);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Text('notif'),
        ),
        body: Row(
          children: [
            Container(
              decoration:
                  drawerDecoration, // Fond dégradé du drawer enregistré dans les fichiers de style + ombre
              child: SizedBox(
                width: (responsiveFormat == ResponsiveFormats.small ||
                        responsiveFormat == ResponsiveFormats.mobile)
                    ? 60
                    : 300,
                child: ListView.builder(
                    // Construction du drawer
                    padding: (responsiveFormat == ResponsiveFormats.small ||
                            responsiveFormat == ResponsiveFormats.mobile)
                        ? const EdgeInsets.only(right: 10)
                        : const EdgeInsets.only(right: 20),
                    itemCount: drawerEntries.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        // Si l'index est égal à 0, alors on affiche le logo de l'application
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          child: RotatedBox(
                            quarterTurns:
                                (responsiveFormat == ResponsiveFormats.small ||
                                        responsiveFormat ==
                                            ResponsiveFormats.mobile)
                                    ? 3
                                    : 0,
                            child: Image.asset(
                              "${releasePath}logos/LOGO_SCO2.png",
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            // Ici, on appelle le provider du selectedIndex pour changer d'écran en fonction de l'option du menu choisie
                            Provider.of<IndexProvider>(context, listen: false)
                                .setSelectedIndex(
                                    index); // On change l'index (voir liste des index dans [webDrawerStyle.dart])
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration:
                                drawerTileShadow, // Ombre des options depuis le style
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    drawerEntries[index][1],
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  if (responsiveFormat == // Pas de titre d'option sur les petits écrans
                                          ResponsiveFormats.small ||
                                      responsiveFormat ==
                                          ResponsiveFormats.mobile)
                                    const SizedBox(
                                      width: 0,
                                      height: 0,
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        drawerEntries[index]
                                            [0], // titre de l'option
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
            Consumer<IndexProvider>(
              // On appelle le consumer pour connaitre en permanence le selectedIndex et donc l'écran choisi dans le menu
              builder: (context, value, child) {
                switch (value.selectedIndex) {
                  // On affiche l'écran correspondant
                  case 1:
                    return const HomeScreen(); // ACCUEIL
                  case 2:
                    return const SearchScreen(); // RECHERCHE
                  case 3:
                    return const ActivityScreen(); // ACTIVITÉS
                  case 4:
                    return const ReportScreen(); // RAPPORT
                  case 5:
                    return const LeaderBoardScreeen(); // CLASSEMENT
                  case 6:
                    return const MessagesScreen(); // MESSAGES
                  case 7:
                    return const SettingsScreen(); // PARAMÈTRES
                  default:
                    return const HomeScreen(); // ACCUEIL
                }
              },
            )
          ],
        ));
  }
}
