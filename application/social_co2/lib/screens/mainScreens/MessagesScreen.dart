import 'package:flutter/material.dart';
import 'package:social_co2/styles/MainScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int drawerWidth = getDrawerWidth(context);

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width -
            drawerWidth, // On défini la largeur du conteneur pour qu'il prenne tout l'espace à droite du drawer sur le web
        decoration: homeScreenBackground,
        child: const Center(
          child: Text("Messagerie non disponible", style: TextStyle(color: Colors.white, fontSize: 25),),
        ));
  }
}
