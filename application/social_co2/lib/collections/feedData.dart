import 'package:flutter/material.dart';

const List<Map<String, dynamic>> moodCollection = [
  {
    "icon": Image(image: AssetImage("icons/sentiment_calm.png")),
    "label": "Chanceux"
  },
  {"icon": Image(image: AssetImage("icons/mood.png")), "label": "Heureux"},
  {"icon": Image(image: AssetImage("icons/mood_bad.png")), "label": "Choqué"},
  {
    "icon": Image(image: AssetImage("icons/sentiment_neutral.png")),
    "label": "Sans mots"
  },
  {
    "icon": Image(image: AssetImage("icons/sentiment_excited.png")),
    "label": "Hyper bien"
  },
  {"icon": Image(image: AssetImage("icons/sick.png")), "label": "Malade"},
  {
    "icon": Image(image: AssetImage("icons/sentiment_very_satisfied.png")),
    "label": "Bien"
  },
  {
    "icon":
        Image(image: AssetImage("icons/sentiment_extremely_dissatisfied.png")),
    "label": "En colère"
  },
];
