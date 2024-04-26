import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/SCO2ReportProvider.dart';
import 'package:social_co2/screens/widgets/ActivitiesList.dart';
import 'package:social_co2/styles/MainScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    int drawerWidth = getDrawerWidth(context);

    return Consumer<SCO2ReportProvider>(
      builder: (context, PROVIDERVALUES, child) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width -
              drawerWidth, // On défini la largeur du conteneur pour qu'il prenne tout l'espace à droite du drawer sur le web
          decoration: homeScreenBackground,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  Container(
                    child: Text('data'),
                  ),
                  /* Builder(builder: (context) {
                    List<Widget> dayslist = List<Container>();
                    for (var i = 0; i < strings.length; i++) {
                      list.add(Text(strings[i]));
                    }
                    return Row(children: list);
                  }) */
                ],
              ),
            ),
          )),
    );
  }
}
