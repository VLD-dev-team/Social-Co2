import 'package:flutter/material.dart';

class IndexProvider extends ChangeNotifier {
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
