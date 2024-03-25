import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:social_co2/collections/credentials.dart';

class DirectionProvider extends ChangeNotifier {
  // Variable spécifique au provider
  bool isLoading = false;
  String error = "";
  double distance = 0;

  Future<double> getDistanceBetweenAdresses(String start, String end) async {
    isLoading = true;
    error = "";
    notifyListeners();

    // On construit l'url
    String openRouteApiURL =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$openRouteAPIkey&start=$start&end=$end';

    // Initialisation des données
    Map<String, dynamic> data = {};

    // On envoie la requette
    try {
      final url = Uri.parse(openRouteApiURL);

      final response = await http.get(url);
      data = json.decode(response.body);
      print(data);
      distance = data['feature']['properties']['summary']['distance'];
    } catch (err) {
      data = {"error": true, "error_message": err.toString()};
      error = "";
      distance = 0;
    }

    // On renvoie la distance en km
    isLoading = false;
    notifyListeners();
    return distance;
  }
}
