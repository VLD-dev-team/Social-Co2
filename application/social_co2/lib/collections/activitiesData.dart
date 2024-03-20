import 'package:flutter/material.dart';

List<Map<String, dynamic>> activeActivityTypes = [
  {
    "type": "meal",
    "label": "Repas",
    "icon": const Icon(Icons.restaurant, color: Colors.black)
  },
  {
    "type": "purchase",
    "label": "Achat",
    "icon": const Icon(Icons.shopping_bag, color: Colors.black)
  },
  {
    "type": "build",
    "label": "Bricolage",
    "icon": const Icon(Icons.build, color: Colors.black)
  },
  {
    "type": "route",
    "label": "Trajet",
    "icon": const Icon(Icons.route, color: Colors.black)
  },
  {
    "type": "cleanInbox",
    "label": "Repas",
    "icon": const Icon(Icons.delete_forever, color: Colors.black)
  },
];


/* 

const activite = {
    "emission_chauffage" : {
      "pellet":6, 
      "electrique":8,
      "poele a bois":9,
      "gaz":39,
      "fioul":57
      },
    "emission_vehicule" : {
      "Grosse voiture hybride" : 110,
      "Moyenne voiture hybride" : 100,
      "Petite voiture hybride" : 80,
      "Grosse voiture" : 195,
      "Moyenne voiture" : 180,
      "Petite voiture" : 175,
      "voiture_electrique":20,
      "moto":165,
      "bus":110,
      "avion":250,
      "ter":22,
      "rer":10,
      "tgv":2.3,
      "a_pied":0,
      "velo":0,
      "velo ou trotinnette electrique":2,
      "metro":4.2,
      "tram":4.3,
      "covoiturage":55,
    },
    "emission_article" : {
      "vetement":10,
      "electromenager":300,
      "ordinateur":150,
      "telephone":40
    },
    "emission_aliment" : {
      "vegetarien":0.5,
      "poisson gras":1,
      "poisson blanc":2,
      "poulet":1.6,
      "boeuf":7,
      "autre viande":2
      },
    "emission_mobilier" : {
      "chaise":19,
      "table":80,
      "canape":180,
      "lit":450,
      "armoire":900
    }
  }

 */