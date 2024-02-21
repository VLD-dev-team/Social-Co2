import 'package:flutter/material.dart';

// Liste des options possible dans le menu latéral
final List<List> drawerEntries = <List>[
  ["Logo", Icons.home_outlined], // logo de l'application dans le menu
  ["Accueil", Icons.home_outlined],
  ["Recherche", Icons.search_outlined],
  ["Activité", Icons.energy_savings_leaf_outlined],
  ["Rapport", Icons.feedback_outlined],
  ["Messages", Icons.message_outlined],
  ["Paramètres", Icons.settings_outlined],
  ["Aide", Icons.help_outline],
];

// Fond dégradé du menu
const LinearGradient drawerBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 108, 163, 94),
      Color.fromARGB(255, 99, 136, 137)
    ]);

// Design des options du menu
const BoxDecoration drawerTileShadow = BoxDecoration(
  borderRadius:
      BorderRadius.horizontal(right: Radius.circular(25), left: Radius.zero),
  boxShadow: [
    BoxShadow(color: Color.fromARGB(99, 66, 66, 66)),
    BoxShadow(
      color: Colors.white,
      offset: Offset(0, 2),
      blurRadius: 1,
      spreadRadius: -1,
    )
  ],
);

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