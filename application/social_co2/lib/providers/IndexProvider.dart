import 'package:flutter/material.dart';

class IndexProvider extends ChangeNotifier {
  int selectedIndex = 1;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
