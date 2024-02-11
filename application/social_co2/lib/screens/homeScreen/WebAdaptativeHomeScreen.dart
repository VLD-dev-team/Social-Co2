import 'package:flutter/material.dart';

class WebAdaptativeHomeScreen extends StatefulWidget {
  const WebAdaptativeHomeScreen({super.key});

  @override
  State<WebAdaptativeHomeScreen> createState() =>
      _WebAdaptativeHomeScreenState();
}

class _WebAdaptativeHomeScreenState extends State<WebAdaptativeHomeScreen> {
  @override
  // TODO : À commenter
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1000) {
        // Utilisation sur un écran large
        return const Text("Écran large");
      } else if (constraints.maxWidth >= 1200) {
        // Utilisation sur un écran moyen
        return const Text("Écran large");
      } else if (constraints.maxWidth >= 800) {
        // Utilisation web sur un écran très peu large
        return const Text("Écran web peu large");
      } else {
        // Utilisation mobile
        return const Text("data");
      }
    });
  }
}