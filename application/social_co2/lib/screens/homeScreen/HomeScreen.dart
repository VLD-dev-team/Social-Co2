// Importation des packages requis pour flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/IndexProvider.dart';

// Importation des styles et du module responsive
import '../../styles/HomeScreenStyle.dart';
import '../../utils/responsiveHandler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveFormats responsive_format = whichResponsiveFormat(context);

    return Consumer<IndexProvider>(
      // On appelle le consumer pour connaitre en permanence le selectedIndex et donc l'écran choisi dans le menu
      builder: (context, value, child) {
        return Container(
            decoration: HomeScreenBackground,
            child: Text('Index : ${value.selectedIndex}'));
      },
    );
  }
}
