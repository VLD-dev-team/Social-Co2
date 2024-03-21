import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/collections/activitiesData.dart';
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

  Column routeMenu() {
    return Column(
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
                      children: const [
                        Text("Départ"),
                        SizedBox(height: 5),
                        TextField(
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
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
                      children: const [
                        Text("Arrivée"),
                        SizedBox(height: 5),
                        TextField(
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Entrez une adresse',
                            ))
                      ],
                    ))
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
        Container(
          decoration: primaryCard,
          child: Wrap(
            spacing: 5.0,
            children: List<ChoiceChip>.generate(availableVehicles.length,
                (int index) {
              var vehicule = availableVehicles[index];
              return ChoiceChip(
                  label: vehicule['label'], selected: routeMode == index);
            }),
          ),
        )
      ],
    );
  }
}
