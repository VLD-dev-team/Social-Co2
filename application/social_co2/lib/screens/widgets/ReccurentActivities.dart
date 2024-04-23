import 'package:flutter/material.dart';
import 'package:social_co2/styles/CardStyles.dart';

class ReccurentActivities extends StatelessWidget {
  const ReccurentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height-630,
      decoration: primaryCard,
      child: 
      const Column(
        crossAxisAlignment: 
        CrossAxisAlignment.center,
        children: [
          SizedBox(
            //widget qui permet d'adapter la taille
            width: 300, //largeur de la sizedbox
            child: Card(
              //Widget Card dans le widget SizedBox qui contiendra le titre
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Center(
                  child: Text(
                    "Activités récurrentes", //titre
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
