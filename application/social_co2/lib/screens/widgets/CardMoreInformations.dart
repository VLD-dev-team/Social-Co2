import 'package:flutter/material.dart';
import 'package:social_co2/collections/MoreInformationsData.dart';
import 'package:social_co2/styles/CardStyles.dart';

class CardMoreInformations extends StatefulWidget {
  const CardMoreInformations({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CardMoreInformations();
}

class _CardMoreInformations extends State<CardMoreInformations> {
  HeatingModes? _heatingModes = HeatingModes.gaz;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        decoration: primaryCard,
        child: Column(children: [
          Wrap(
            children: const [
              Card(
                margin: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Center(
                    child: Text(
                      "Informations complémentaires",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.only(
                  top: 5, bottom: 15, left: 10, right: 10),
              decoration: secondaryCardInnerShadow,
              child: ListView(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: const ListTile(
                        title: Text("Maison"),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: const ListTile(
                          leading: Text("Nombre de m² : "),
                          trailing: SizedBox(
                              width: 60,
                              child: TextField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number)))),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: Column(
                        children: [
                          const ListTile(
                            leading: Text("Type de chauffage"),
                          ),
                          Wrap(
                            children: [
                              SizedBox(
                                child: GestureDetector(
                                  child: Wrap(
                                    children: [
                                      Radio<HeatingModes>(
                                          value: HeatingModes.bois,
                                          groupValue: _heatingModes,
                                          onChanged: (HeatingModes? value) {
                                            setState(() {
                                              _heatingModes = value;
                                            });
                                          }),
                                      const Text("Bois")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
          )
        ]));
  }
}
