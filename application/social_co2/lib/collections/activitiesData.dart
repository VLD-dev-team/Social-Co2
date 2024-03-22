import 'package:flutter/material.dart';

List<Map<String, dynamic>> activeActivityTypes = [
  {
    "type": "meal",
    "label": "Repas",
    "icon": const Icon(Icons.restaurant, color: Colors.black),
    "next": true
  },
  {
    "type": "purchase",
    "label": "Achat",
    "icon": const Icon(Icons.shopping_bag, color: Colors.black),
    "next": true
  },
  {
    "type": "build",
    "label": "Bricolage",
    "icon": const Icon(Icons.build, color: Colors.black),
    "next": true
  },
  {
    "type": "route",
    "label": "Trajet",
    "icon": const Icon(Icons.route, color: Colors.black),
    "next": true
  },
  {
    "type": "cleanInbox",
    "label": "Vider sa boite email",
    "icon": const Icon(Icons.delete_forever, color: Colors.black),
    "next": false
  },
];

List<Map<String, dynamic>> meals = [
  {"type": "vegetarien", "label": "Végétarien"},
  {
    "type": "oilyfish",
    "label":
        "Poisson gras (Maquereau, Sardine, Saumon, Anchois, Hareng, Truite, Anguille fumée, thon)"
  },
  {
    "type": "whitefish",
    "label":
        "Poisson Blanc (Cabillaud, Merlu, Colin, Mérou, Lotte, Sole, Dorade, Grenadier)"
  },
  {"type": "chicken", "label": "Poulet"},
  {"type": "beef", "label": "Boeuf"},
  {"type": "other", "label": "Autre viande"}
];

List<Map<String, dynamic>> purchases = [
  {"type": "newclothes", "label": "Vêtements 1ère main"},
  {"type": "reusedclothes", "label": "Vêtements 2nd main"},
  {"type": "homeappliance", "label": "Éléctroménager"},
  {"type": "computer", "label": "Ordinateur"},
  {"type": "smartphone", "label": "Téléphone"}
];

List<Map<String, dynamic>> builds = [
  {"type": "table", "label": "Table"},
  {"type": "chair", "label": "Chaise"},
  {"type": "sofa", "label": "Canapé"},
  {"type": "bed", "label": "Lit"},
  {"type": "wardrobe", "label": "Armoire"}
];

List<Map<String, dynamic>> availableVehicles = [
  {"type": "car", "label": "Voiture", "icon": const Icon(Icons.directions_car)},
  {
    "type": "electriccar",
    "label": "Voiture éléctrique",
    "icon": const Icon(Icons.electric_car)
  },
  {"type": "motorcycle", "label": "Moto", "icon": const Icon(Icons.motorcycle)},
  {"type": "bus", "label": "Bus", "icon": const Icon(Icons.directions_bus)},
  {"type": "plane", "label": "Avion", "icon": const Icon(Icons.flight)},
  {"type": "train", "label": "TER", "icon": const Icon(Icons.train)},
  {"type": "rer", "label": "RER", "icon": const Icon(Icons.directions_railway)},
  {"type": "highspeedtrain", "label": "TGV", "icon": const Icon(Icons.train)},
  {
    "type": "walking",
    "label": "À pied",
    "icon": const Icon(Icons.directions_walk)
  },
  {"type": "bicycle", "label": "Vélo", "icon": const Icon(Icons.pedal_bike)},
  {
    "type": "electricbike",
    "label": "Vélo Elec.",
    "icon": const Icon(Icons.electric_bike)
  },
  {"type": "metro", "label": "Metro", "icon": const Icon(Icons.subway)},
  {"type": "tram", "label": "Tramway", "icon": const Icon(Icons.tram)},
  {
    "type": "carpooling",
    "label": "Covoiturage",
    "icon": const Icon(Icons.groups)
  }
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
