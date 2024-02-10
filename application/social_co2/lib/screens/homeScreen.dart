import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) {
          // Utilisation sur un écran large
          return Text("Ércran large");
        } else if (constraints.maxWidth >= 1200) {
          // Utilisation sur un écran moyen
          return Text("Ércran large");
        } else if (constraints.maxWidth >= 800) {
          // Utilisation web sur un écran très peu large
          return Text("Écran web peu large");
        } else {
          // Utilisation mobile
          return Text("Mobile");
        }
      }),
    );
  }
}
