// Importation des packages requis pour flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importation des styles et des providers pour le menu/drawer
import 'package:social_co2/screens/mainScreen/styles/webDrawersStyle.dart';
import 'package:social_co2/models/IndexProvider.dart';

class WebAdaptativeMainScreen extends StatefulWidget {
  const WebAdaptativeMainScreen({super.key});

  @override
  State<WebAdaptativeMainScreen> createState() =>
      _WebAdaptativeMainScreenState();
}

class _WebAdaptativeMainScreenState extends State<WebAdaptativeMainScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    return ChangeNotifierProvider(
        // Création du Provider à partir du modèle IndexProvider
        create: (_) =>
            IndexProvider(), // Ce modèle va nous permettre de changer d'écran principal en cliquant sur les options du menu
        builder: (context, child) {
          // Cette configuration a l'avantage de pouvoir passer la variable selectedIndex dans plusieurs fichiers sans avoir à ce soucier du state
          return Scaffold(
              body: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient:
                        drawerBackground), // Fond dégradé du drawer enregistré dans les fichiers de style
                child: SizedBox(
                  width: 300, // TODO: à adapter pour les tailles d'écran
                  child: ListView.builder(
                      // Construction du drawer
                      padding: const EdgeInsets.only(right: 20),
                      itemCount: drawerEntries.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          // Si l'index est égal à 0, alors on affiche le logo de l'application
                          return Container(
                            // TODO : Implémenter le logo et le clic sur le logo
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            child: const Text(
                              "SCO2",
                              style: TextStyle(fontSize: 70),
                            ),
                          );
                        } else {
                          return Container(
                            // Puis on affiche les autres options du menu
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration:
                                drawerTileShadow, // Design des options du drawer dans les fichier style
                            child: ListTile(
                              onTap: () {
                                // Ici, on appelle le provider du selectedIndex pour changer d'écran en fonction de l'option du menu choisie
                                Provider.of<IndexProvider>(context,
                                        listen: false)
                                    .setSelectedIndex(
                                        index); // On change l'index (voir liste des index dans [webDrawerStyle.dart])
                              },
                              title: Text(
                                drawerEntries[index][0], // titre de l'option
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                              leading: Icon(
                                  drawerEntries[index][1]), // Icon de l'option
                              iconColor: Colors.black,
                              textColor: Colors.black,
                            ),
                          );
                        }
                      }),
                ),
              ),
              Container(
                  // Conteneur de l'écran selectionné depuis le menu
                  decoration:
                      const BoxDecoration(color: Color.fromARGB(100, 0, 0, 0)),
                  child: Consumer<IndexProvider>(
                    // On appelle le consumer pour connaitre en permanence le selectedIndex et donc l'écran choisi dans le menu
                    builder: (context, value, child) {
                      return Text('index: ${value.selectedIndex}'); 
                    },
                  ))
            ],
          ));
        });
  }
}
