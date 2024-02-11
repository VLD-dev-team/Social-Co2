import 'package:flutter/material.dart';

class MobileAdaptativeHomeScreen extends StatefulWidget {
  const MobileAdaptativeHomeScreen({super.key});

  @override
  State<MobileAdaptativeHomeScreen> createState() =>
      _MobileAdaptativeHomeScreenState();
}

class _MobileAdaptativeHomeScreenState
    extends State<MobileAdaptativeHomeScreen> {
  int selectedIndex =
      0; // Index de l'onglet actuellement selectionné dans la BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    // TODO : À commenter
    return Scaffold(
        body: const Text("Mobile Natif"),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Accueil"),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard_outlined), label: "Classement"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined), label: "Ajouter"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined), label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: "Profil")
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ));
  }
}
