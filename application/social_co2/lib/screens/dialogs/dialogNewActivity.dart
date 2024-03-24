import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/collections/activitiesData.dart';
import 'package:social_co2/providers/DirectionsProvider.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class newActivityDialog extends StatefulWidget {
  const newActivityDialog({super.key});

  @override
  State<StatefulWidget> createState() => _newActivityDialog();
}

class _newActivityDialog extends State<newActivityDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Variable du menu actuellement affiché
  String _currentMenu = "main";

  // Mode de transport selectionné
  int? routeMode = 0;

  // Controller des champs de text de route
  final startController = TextEditingController();
  final endController = TextEditingController();
  final distanceController = TextEditingController();

  // Widget de dialogbox avec le menu actuellement affiché
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        // Importation du provider UserActivitiesProvider
        create: (context) => UserActivitiesProvider(),
        builder: ((context, child) {
          return Consumer<UserActivitiesProvider>(
              builder: (context, value, child) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: secondaryCardColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    disabledColor: Colors.transparent,
                    onPressed: (_currentMenu == "main")
                        ? null
                        : () {
                            setState(() {
                              _currentMenu = "main";
                            });
                          },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Center(
                      child: Container(
                          decoration: primaryCard,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              'Ajouter une activité',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ))),
                  IconButton(
                      onPressed: (value.isPosting)
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      icon: const Icon(Icons.close)),
                ],
              ),
              content: SizedBox(
                height: 400,
                width: 600,
                child: chooseMenu(
                    _currentMenu), // On affiche le menu selectionné ou main si le dialog vient d'apparaitre
              ),
              actions: [
                if (_currentMenu == "route" && !value.isPosting)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 20, left: 20, right: 20),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          value.postRouteActivity(
                              availableVehicles[routeMode!]["type"],
                              double.parse(distanceController.text));
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Envoyer')),
                  )
              ],
            );
          });
        }));
  }

  // Fonction de selection du menu selon la variable _currentmenu
  Widget chooseMenu(label) {
    switch (label) {
      case "main":
        return mainList();
      case "meal":
        return mealList();
      case "purchase":
        return purchaseList();
      case "build":
        return buildList();
      case "route":
        return routeMenu();
      default:
        return mainList();
    }
  }

  // Menu principal
  ListView mainList() {
    return ListView.separated(
      itemCount: activeActivityTypes.length,
      itemBuilder: (context, index) {
        var activity = activeActivityTypes[index];
        return ListTile(
          onTap: () {
            if (activity['type'] == 'cleanInbox') {
              Provider.of<UserActivitiesProvider>(context, listen: false)
                  .postEmailActivity();
            } else {
              setState(() {
                _currentMenu = activity['type'];
              });
            }
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          tileColor: primaryCardColor,
          leading: CircleAvatar(
            backgroundColor: secondaryCardColor,
            child: activity["icon"],
          ),
          title: Center(child: Text('${activity["label"]}')),
          trailing: Icon(Icons.chevron_right,
              color: (activity['next']) ? Colors.black : Colors.transparent),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }

  ListView mealList() {
    return ListView.separated(
        itemBuilder: ((context, index) {
          var meal = meals[index];
          return ListTile(
            title: Text(meal['label']),
            tileColor: primaryCardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minVerticalPadding: 10,
            onTap: () {
              Provider.of<UserActivitiesProvider>(context, listen: false)
                  .postMealActivity(meal['type']);
            },
          );
        }),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: meals.length);
  }

  ListView purchaseList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          var purchase = purchases[index];
          return ListTile(
            title: Text(purchase['label']),
            tileColor: primaryCardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minVerticalPadding: 10,
            onTap: () {
              Provider.of<UserActivitiesProvider>(context, listen: false)
                  .postPurchaseActivity(purchase['type']);
            },
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(height: 10)),
        itemCount: purchases.length);
  }

  ListView buildList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          var build = builds[index];
          return ListTile(
            title: Text(build['label']),
            tileColor: primaryCardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minVerticalPadding: 10,
            onTap: () {
              Provider.of<UserActivitiesProvider>(context, listen: false)
                  .postBuildActivity(build['type']);
            },
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(height: 10)),
        itemCount: builds.length);
  }

  dynamic routeMenu() {
    return ChangeNotifierProvider(
      create: (context) => DirectionProvider(),
      builder: (context, child) => ListView(
        children: [
          // Conteneur haut avec itinéraire
          Container(
            decoration: primaryCard,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Départ"),
                          const SizedBox(height: 5),
                          TextField(
                            controller: startController,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Entrez une adresse',
                            ),
                          )
                        ],
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Arrivée"),
                          const SizedBox(height: 5),
                          TextField(
                              controller: endController,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Entrez une adresse',
                              ))
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            var start = startController.text;
                            var end = endController.text;
                            Provider.of<DirectionProvider>(context,
                                    listen: false)
                                .getDistanceBetweenAdresses(start, end)
                                .then((value) {
                              distanceController.text = value.toString();
                            });
                          },
                          icon: const Icon(Icons.route),
                          label: const Text('Calculer la distance')),
                      Consumer<DirectionProvider>(
                          builder: ((context, value, child) {
                        if (value.isLoading) {
                          return const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ));
                        } else if (value.error == "") {
                          return Text(value.error);
                        } else {
                          return const Text("OpenRouteService API");
                        }
                      }))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Nombre de Km"),
                      SizedBox(height: 5),
                      TextField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Entrez une adresse',
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          // Conteneur bas avec mode de transport
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: primaryCard,
              child: Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                children: List<ChoiceChip>.generate(availableVehicles.length,
                    (int index) {
                  var vehicule = availableVehicles[index];
                  return ChoiceChip(
                      onSelected: (value) {
                        setState(() {
                          routeMode = index;
                        });
                      },
                      avatar: vehicule["icon"],
                      label: Text(vehicule['label']),
                      selected: routeMode == index);
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
