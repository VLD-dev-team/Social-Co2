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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        // Importation du provider UserActivitiesProvider
        create: (context) => UserActivitiesProvider(),
        builder: ((context, child) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: secondaryCardColor,
            title: Center(
                child: Container(
                    decoration: primaryCard,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'Ajouter une activité',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ))),
            content: SizedBox(
              height: 400,
              width: 600,
              child: ListView.separated(
                itemCount: activeActivityTypes.length,
                itemBuilder: (context, index) {
                  var activity = activeActivityTypes[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: primaryCardColor,
                    leading: CircleAvatar(
                      backgroundColor: secondaryCardColor,
                      child: activity["icon"],
                    ),
                    title: Center(child: Text('${activity["label"]}')),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              ),
            ),
          );
        }));
  }
}
