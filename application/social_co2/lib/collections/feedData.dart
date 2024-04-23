import 'package:flutter/material.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

List<Map<String, dynamic>> moodCollection = [
  {
    "icon": Image(image: AssetImage("${releasePath}icons/sentiment_calm.png")),
    "label": "Chanceux"
  },
  {
    "icon": Image(image: AssetImage("${releasePath}icons/mood.png")),
    "label": "Heureux"
  },
  {
    "icon": Image(image: AssetImage("${releasePath}icons/mood_bad.png")),
    "label": "Choqué"
  },
  {
    "icon":
        Image(image: AssetImage("${releasePath}icons/sentiment_neutral.png")),
    "label": "Sans mots"
  },
  {
    "icon":
        Image(image: AssetImage("${releasePath}icons/sentiment_excited.png")),
    "label": "Hyper bien"
  },
  {
    "icon": Image(image: AssetImage("${releasePath}icons/sick.png")),
    "label": "Malade"
  },
  {
    "icon": Image(
        image: AssetImage("${releasePath}icons/sentiment_very_satisfied.png")),
    "label": "Bien"
  },
  {
    "icon": Image(
        image: AssetImage(
            "${releasePath}icons/sentiment_extremely_dissatisfied.png")),
    "label": "En colère"
  },
];
