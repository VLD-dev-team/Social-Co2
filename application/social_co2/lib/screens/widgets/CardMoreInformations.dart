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
  HeatingModes? _selectedHeatingMode = HeatingModes.gaz;
  CarSizes? _selectedCarSize = CarSizes.mid;
  bool isCarHybrid = false;
  bool saved = true;

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
                      child: ListTile(
                        title: const Text("Maison"),
                        subtitle: Wrap(
                          children: const [
                            Text(
                                "Informations sur votre lieu de vie principal.")
                          ],
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: ListTile(
                          title: const Text("Nombre de m² : "),
                          trailing: SizedBox(
                              width: 60,
                              child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      saved = false;
                                    });
                                  },
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number)))),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ListTile(
                            title: Text("Type de chauffage"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: [
                                heatModeRadioButton(HeatingModes.bois),
                                heatModeRadioButton(HeatingModes.electrique),
                                heatModeRadioButton(HeatingModes.fioul),
                                heatModeRadioButton(HeatingModes.gaz),
                                heatModeRadioButton(HeatingModes.pellet),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: ListTile(
                          title: const Text("Nombre de chauffage : "),
                          trailing: SizedBox(
                              width: 60,
                              child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      saved = false;
                                    });
                                  },
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number)))),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: ListTile(
                          title: Text(
                              "Date de construction du batiments (ou date de rénovation): "),
                          trailing: SizedBox(
                              width: 60,
                              child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      saved = false;
                                    });
                                  },
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number)))),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: const Text("Voiture personnelle"),
                        subtitle: Wrap(
                          children: const [
                            Text(
                                "Si votre voiture principale est 100% éléctrique, cette section est facultative")
                          ],
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ListTile(
                            title: Text("Taille du vehicule"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: [
                                CarSizeRadioButton(CarSizes.small),
                                CarSizeRadioButton(CarSizes.mid),
                                CarSizeRadioButton(CarSizes.big),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            saved = false;
                            isCarHybrid = !isCarHybrid;
                          });
                        },
                        child: ListTile(
                            title: const Text("Hybride : "),
                            trailing: SizedBox(
                                width: 60,
                                child: Switch(
                                    value: isCarHybrid,
                                    onChanged: (bool value) {
                                      setState(() {
                                        saved = false;
                                        isCarHybrid = value;
                                      });
                                    }))),
                      )),
                ],
              ),
            ),
          ),
          if (!saved)
            FloatingActionButton.extended(
              icon: const Icon(Icons.save),
              label: const Text("Sauvegarder"),
              onPressed: () {
                setState(() {
                  saved = true;
                });
              },
            ),
          if (!saved)
            const SizedBox(
              height: 15,
            )
        ]));
  }

  SizedBox heatModeRadioButton(HeatingModes mode) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedHeatingMode = mode;
            saved = false;
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Radio<HeatingModes>(
                value: mode,
                groupValue: _selectedHeatingMode,
                onChanged: (HeatingModes? value) {
                  setState(() {
                    saved = false;
                    _selectedHeatingMode = value;
                  });
                }),
            Text('${heatingModesNames[mode]}')
          ],
        ),
      ),
    );
  }

  SizedBox CarSizeRadioButton(CarSizes size) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          setState(() {
            saved = false;
            _selectedCarSize = size;
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Radio<CarSizes>(
                value: size,
                groupValue: _selectedCarSize,
                onChanged: (CarSizes? value) {
                  setState(() {
                    saved = false;
                    _selectedCarSize = value;
                  });
                }),
            Text('${carSizesNames[size]}')
          ],
        ),
      ),
    );
  }
}
