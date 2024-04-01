import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<Map<String, dynamic>> searchResults = [];
  bool searching = true;

  Future<List<Map<String, dynamic>>> search(query) async {
    print("Recherche lancé pour $query");

    // TODO: Faire la requette

    searching = false;
    notifyListeners();
    return searchResults;
  }
}
