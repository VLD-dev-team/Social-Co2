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
    // Variables necessaires au responsive
    ResponsiveFormats responsiveFormat = whichResponsiveFormat(context);
    int drawerWidth = getDrawerWidth(context);

    return Consumer<IndexProvider>(
      // On appelle le consumer pour connaitre en permanence le selectedIndex et donc l'écran choisi dans le menu
      builder: (context, value, child) {
        return Center(
          child: Container(
              width: MediaQuery.of(context).size.width - drawerWidth,
              decoration: homeScreenBackground,
              child: Row(
                children: [
                  SizedBox(
                      width: (MediaQuery.of(context).size.width - drawerWidth) /
                          3 *
                          2,
                      child: Column(children: const [Text("data")])),
                  //Spacer(flex: 1,),
                  SizedBox(
                      width:
                          (MediaQuery.of(context).size.width - drawerWidth) / 3,
                      child: SingleChildScrollView(
                          child: Column(children: const [Text("data")]))),
                ],
              )),
        );
      },
    );
  }
}
