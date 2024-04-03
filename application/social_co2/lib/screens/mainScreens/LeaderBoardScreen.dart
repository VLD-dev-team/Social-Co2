import 'package:flutter/material.dart';
import 'package:social_co2/screens/widgets/LeaderBoardWidget.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/styles/MainScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class LeaderBoardScreeen extends StatelessWidget {
  const LeaderBoardScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveFormats responsiveFormat = whichResponsiveFormat(context);
    int drawerWidth = getDrawerWidth(context);

    if (drawerWidth==60) {
      return Container(
  width: MediaQuery.of(context).size.width-drawerWidth, // Largeur de l'écran
  height: MediaQuery.of(context).size.height, // Hauteur de l'écran
  decoration: homeScreenBackground,
  child: const LeaderBoardWidget(indexAffichage: 2,),
);

    } else if(drawerWidth==300) {
      return Container(decoration : homeScreenBackground ,child :const LeaderBoardWidget(indexAffichage: 3));
    }
    else{
      return const Text("Erreur affichage");
    }
}
}
