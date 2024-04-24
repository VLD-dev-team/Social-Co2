import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/SCO2ReportProvider.dart';
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
      builder: (context, value, child) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width -
              drawerWidth, // On défini la largeur du conteneur pour qu'il prenne tout l'espace à droite du drawer sur le web
          decoration: homeScreenBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('data')],
                ),
              )
            ],
          )),
    );
  }
}
