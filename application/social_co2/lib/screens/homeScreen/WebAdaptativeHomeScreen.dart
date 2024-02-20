import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/screens/homeScreen/styles/webDrawersStyle.dart';

class WebAdaptativeHomeScreen extends StatefulWidget {
  const WebAdaptativeHomeScreen({super.key});

  @override
  State<WebAdaptativeHomeScreen> createState() =>
      _WebAdaptativeHomeScreenState();
}

/* TODO : à supprimer en prod : ce comm sert juste à se rappeler des dimensions
 
 LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 1400) {
          // Utilisation sur un écran large -> Medium et max sur Figma
          return const Text("Écran très large");
        } else if (constraints.maxWidth >= 1200) {
          // Utilisation sur un écran moyen -> Small sur Figma
          return const Text("Écran large");
        } else if (constraints.maxWidth >= 700) {
          // Utilisation web sur un écran très peu large -> XSmall sur Figma
          return const Text("Écran web peu large");
        } else {
          // Utilisation mobile
          return const Text("téléchargez l'application");
        }
      })

*/

class _WebAdaptativeHomeScreenState extends State<WebAdaptativeHomeScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final List<List> drawerEntries = <List>[
      ["Accueil", Icons.home_outlined],
      ["Recherche", Icons.search_outlined],
      ["Activité", Icons.energy_savings_leaf_outlined],
      ["Rapport", Icons.feedback_outlined],
      ["Messages", Icons.message_outlined],
      ["Paramètres", Icons.settings_outlined],
      ["Aide", Icons.help_outline],
    ];
    int selectedIndex = 0;

    void changeIndex(index) {
      print(index);
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
        body: Row(
      children: [
        Container(
          decoration: const BoxDecoration(gradient: drawerBackground),
          child: SizedBox(
            width: 300,
            child: ListView.builder(
                padding: const EdgeInsets.only(right: 20),
                itemCount: drawerEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(25), left: Radius.zero),
                      boxShadow: [
                        BoxShadow(color: Color.fromARGB(99, 66, 66, 66)),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, 2),
                          blurRadius: 1,
                          spreadRadius: -1,
                        )
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        changeIndex(index);
                      },
                      title: Text(
                        drawerEntries[index][0],
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      leading: Icon(drawerEntries[index][1]),
                      iconColor: Colors.black,
                      textColor: Colors.black,
                    ),
                  );
                }),
          ),
        )
      ],
    ));
  }
}
