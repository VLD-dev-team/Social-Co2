import 'package:flutter/material.dart';
import 'package:social_co2/collections/feedData.dart';
import 'package:social_co2/styles/CardStyles.dart';

class MoodDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryCardColor,
      title: Center(
          child: Container(
              decoration: primaryCard,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
        child: GridView.builder(
            itemCount: moodCollection.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1 / 0.2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  print(index);
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
            }),
      ),
      actions: [
        Padding(
          padding:
              const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
          child: FilledButton.icon(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black)),
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
        )
      ],
    );
  }
}
