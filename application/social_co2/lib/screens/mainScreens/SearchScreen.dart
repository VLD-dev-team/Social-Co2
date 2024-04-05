import 'package:flutter/material.dart';
import 'package:social_co2/screens/widgets/SearchCard.dart';
import 'package:social_co2/screens/widgets/SocialRelationViewer.dart';
import 'package:social_co2/styles/MainScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Variables necessaires au responsive
    int drawerWidth = getDrawerWidth(context);

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width -
            drawerWidth, // On défini la largeur du conteneur pour qu'il prenne tout l'espace à droite du drawer sur le web
        decoration: homeScreenBackground,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [SearchCard(), Expanded(child: SocialRelationViewer())],
        ));
  }
}
