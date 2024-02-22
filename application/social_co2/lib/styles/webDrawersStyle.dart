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
const BoxDecoration drawerDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 108, 163, 94),
          Color.fromARGB(255, 99, 136, 137)
        ]),
    boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 0, 0, 0),
          blurRadius: 4,
          offset: Offset(5, 0)),
    ]);

// Design des options du menu
const BoxDecoration drawerTileShadow = BoxDecoration(
  borderRadius:
      BorderRadius.horizontal(right: Radius.circular(25), left: Radius.zero),
  boxShadow: [
    BoxShadow(color: Color.fromARGB(65, 66, 66, 66)),
    BoxShadow(
      color: Colors.white,
      offset: Offset(0, 2),
      blurRadius: 1,
      spreadRadius: -1,
    )
  ],
);
