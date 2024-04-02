import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/collections/MoreInformationsData.dart';
import 'package:social_co2/providers/UserSCO2DataProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/utils/enumDataParser.dart';

class CardMoreInformations extends StatefulWidget {
  const CardMoreInformations({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CardMoreInformations();
}

class _CardMoreInformations extends State<CardMoreInformations> {
  // Création des controlleurs du formulaire
  bool saved =
      true; // Booléen pour savoir si de nouvelle valeur ont été enregistré
  final surfaceFieldController =
      TextEditingController(); // Controlleur pour connaitre le nombre de m² de la maison
  HeatingModes? _selectedHeatingMode =
      HeatingModes.gaz; // Mode de chauffage selectionné
  bool garden = false; // Jardin ou non
  bool recycling = true; // Recyclage ou non
  CarSizes? _selectedCarSize = CarSizes.mid; // Taille de véhicule selectionné
  bool isCarHybrid = false; // Voiture hybride ou non

  @override
  void initState() {
    super.initState();

    // Obtention des données depuis le provider UserSCO2DataProvider
    surfaceFieldController.value = TextEditingValue(
        text: Provider.of<UserSCO2DataProvider>(context, listen: false)
            .homeSurface
            .toString());
    _selectedHeatingMode =
        Provider.of<UserSCO2DataProvider>(context, listen: false).heatMode;
    garden = Provider.of<UserSCO2DataProvider>(context, listen: false).garden;
    recycling =
        Provider.of<UserSCO2DataProvider>(context, listen: false).recycling;
    _selectedCarSize =
        Provider.of<UserSCO2DataProvider>(context, listen: false).carSize;
    isCarHybrid =
        Provider.of<UserSCO2DataProvider>(context, listen: false).isCarHybrid;
  }

  @override
  Widget build(BuildContext context) {
    // Puis on construit le widget
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
                  Consumer<UserSCO2DataProvider>(
                    builder: (context, value, child) {
                      return Visibility(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: primaryCard,
                        child: ListTile(
                          iconColor: Colors.red,
                          textColor: Colors.red,
                          leading: const Icon(Icons.error),
                          title: const Text(
                              "Une erreur est survenue lors de l'obtention/envoi des données."),
                          subtitle: Text(value.error.toString()),
                          trailing: (value.isLoading)
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    Provider.of<UserSCO2DataProvider>(context,
                                            listen: false)
                                        .getUserSCO2Data();
                                  },
                                  icon: const Icon(Icons.refresh)),
                        ),
                      ));
                    },
                  ),
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
                                  controller: surfaceFieldController,
                                  onChanged: (value) {
                                    // Si la valeur du textfield change, on indique que cette valeur n'a pas été sauvegardé
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
                                // On insère dynamiquement les différents bouton radio
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
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            saved = false;
                            garden = !garden;
                          });
                        },
                        child: ListTile(
                            title: const Text("J'ai un potager : "),
                            trailing: SizedBox(
                                width: 60,
                                child: Switch(
                                    value: garden,
                                    onChanged: (bool value) {
                                      setState(() {
                                        // Si la valeur du switch change, on informe que cette valeur n'a pas été sauvegardé
                                        saved = false;
                                        garden = value;
                                      });
                                    }))),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: primaryCard,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            saved = false;
                            recycling = !recycling;
                          });
                        },
                        child: ListTile(
                            title: const Text("Je recycle : "),
                            trailing: SizedBox(
                                width: 60,
                                child: Switch(
                                    value: recycling,
                                    onChanged: (bool value) {
                                      setState(() {
                                        // Si la valeur du switch change, on informe que cette valeur n'a pas été sauvegardé
                                        saved = false;
                                        recycling = value;
                                      });
                                    }))),
                      )),
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
                                // On insère dynamiquement les différents bouton radio
                                carSizeRadioButton(CarSizes.small),
                                carSizeRadioButton(CarSizes.mid),
                                carSizeRadioButton(CarSizes.big),
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
                                        // Si la valeur du switch change, on informe que cette valeur n'a pas été sauvegardé
                                        saved = false;
                                        isCarHybrid = value;
                                      });
                                    }))),
                      )),
                ],
              ),
            ),
          ),
          if (!saved) // On affiche le bouton de sauvegarde en cas de valeur non sauvegardé
            FloatingActionButton.extended(
              icon: const Icon(Icons.save),
              label: const Text("Sauvegarder"),
              onPressed: () {
                setState(() {
                  final Map<String, dynamic> data = createJson();
                  print(data);
                  Provider.of<UserSCO2DataProvider>(context, listen: false)
                      .updateUserSCO2Data(data)
                      .then((value) => {saved = true});
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
    // BOUTON RADIO DU MODE DE CHAUFFAGE
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          setState(() {
            // On indique la nouvelle valeur comme non sauvegardée
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
                    // On indique la nouvelle valeur comme non sauvegardée
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

  SizedBox carSizeRadioButton(CarSizes size) {
    // BOUTON RADIO DE LA TAILLE DU VEHICULE
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          setState(() {
            // On indique la nouvelle valeur comme non sauvegardée
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
                    // On indique la nouvelle valeur comme non sauvegardée
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

  Map<String, dynamic> createJson() {
    return {
      'area': surfaceFieldController.text.toString(),
      'heating': getHeatingModeLabelFromEnum(_selectedHeatingMode!),
      'garden': garden,
      'recycl': recycling,
      'car': getCarSizeLabelFromEnum(_selectedCarSize!),
      'hybrid': isCarHybrid,
    };
  }
}
