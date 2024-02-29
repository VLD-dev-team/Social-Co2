// Importation des packages requis pour flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/screens/homeScreen/HomeScreen.dart';

// Importation des styles et des providers pour le menu/drawer
import 'package:social_co2/styles/webDrawersStyle.dart';
import 'package:social_co2/providers/IndexProvider.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class WebAdaptativeContainer extends StatefulWidget {
  @override
  State<WebAdaptativeContainer> createState() => _WebAdaptativeContainerState();
}

class _WebAdaptativeContainerState extends State<WebAdaptativeContainer> {
  @override
  Widget build(BuildContext context) {
    ResponsiveFormats responsive_format = whichResponsiveFormat(context);

    return Scaffold(
        body: Row(
      children: [
        Container(
          decoration:
              drawerDecoration, // Fond dégradé du drawer enregistré dans les fichiers de style + ombre
          child: SizedBox(
            width: (responsive_format == ResponsiveFormats.small ||
                    responsive_format == ResponsiveFormats.mobile)
                ? 60
                : 300,
            child: ListView.builder(
                // Construction du drawer
                // TODO: coder une meilleure implémentation -> Trop long pour le responsive
                padding: (responsive_format == ResponsiveFormats.small ||
                        responsive_format == ResponsiveFormats.mobile)
                    ? const EdgeInsets.only(right: 10)
                    : const EdgeInsets.only(right: 20),
                itemCount: drawerEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    // Si l'index est égal à 0, alors on affiche le logo de l'application
                    return Container(
                      // TODO : Implémenter le logo et le clic sur le logo
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Text(
                        "SCO2",
                        style: (responsive_format == ResponsiveFormats.small ||
                                responsive_format == ResponsiveFormats.mobile)
                            ? const TextStyle(fontSize: 10)
                            : const TextStyle(fontSize: 70),
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
                              if (responsive_format == // Pas de titre d'option sur les petits écrans
                                      ResponsiveFormats.small ||
                                  responsive_format == ResponsiveFormats.mobile)
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
              default:
                return const HomeScreen(); // ACCUEIL
            }
          },
        )
      ],
    ));
  }
}
