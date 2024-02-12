import 'package:flutter/material.dart';

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
    int selectedIndex = 0;

    void changeIndex(index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
        body: Row(
      children: [
        NavigationRail(
          backgroundColor: Colors.green,
          extended: true,
          minExtendedWidth: 200,
          minWidth: 80,
          destinations: const [
            NavigationRailDestination(
              label: Text("Accueil"),
              icon: Icon(Icons.home_outlined),
            ),
            NavigationRailDestination(
              label: Text("Recherche"),
              icon: Icon(Icons.search_outlined),
            ),
            NavigationRailDestination(
              label: Text("Activité"),
              icon: Icon(Icons.energy_savings_leaf_outlined),
            ),
            NavigationRailDestination(
              label: Text("Messages"),
              icon: Icon(Icons.message_outlined),
            ),
            NavigationRailDestination(
              label: Text("Classement"),
              icon: Icon(Icons.leaderboard_outlined),
            ),
            NavigationRailDestination(
              label: Text("Paramètres"),
              icon: Icon(Icons.settings_outlined),
            ),
          ],
          selectedIndex: selectedIndex,
          useIndicator: false,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
        )
      ],
    ));
  }
}
