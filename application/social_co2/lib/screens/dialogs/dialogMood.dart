import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/collections/feedData.dart';
import 'package:social_co2/providers/MakePostProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class MoodDialog extends StatelessWidget {
  const MoodDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        // Importation du provider MakePostProvider
        create: (context) => MakePostProvider(),
        builder: ((context, child) {
          return AlertDialog(
            // Création du dialogbox
            backgroundColor: secondaryCardColor,
            title: Center(
                child: Container(
                    decoration: primaryCard,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'Ajouter un mood',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ))),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Consumer<MakePostProvider>(
                // Écoute du provider en cas d'envoi de données vers le serveur
                builder: (context, value, child) {
                  if (value.posting) {
                    return const Center(
                      child: LinearProgressIndicator(),
                    );
                  } else if (value.sended) {
                    return const Center(
                      child: Text("Envoyé !"),
                    );
                  } else {
                    return const MoodGridView();
                  }
                },
              ),
            ),
            actions: [
              // Bouton pour fermer le dialogbox visible quand aucune données ne s'envoie
              Visibility(
                visible: !Provider.of<MakePostProvider>(listen: true, context)
                    .posting,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 20, left: 20, right: 20),
                  child: FilledButton.icon(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Annuler",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              )
            ],
          );
        }));
  }
}

class MoodGridView extends StatelessWidget {
  // GridView dynamique des mood disponible dans les collections
  const MoodGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: moodCollection.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1,
            mainAxisExtent: 80),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Si un mood est selectionné, on effectue la requette vers le serveur via le provider
              Provider.of<MakePostProvider>(listen: false, context)
                  // On poste
                  .postMood(moodCollection[index]['label']);
            },
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: secondaryCardColor,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: moodCollection[index]["icon"]),
                    ),
                    const SizedBox(width: 10),
                    Text(moodCollection[index]["label"])
                  ],
                ),
              ),
            ),
          );
        });
  }
}
