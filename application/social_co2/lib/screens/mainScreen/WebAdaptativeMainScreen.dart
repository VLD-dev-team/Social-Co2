import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_co2/screens/mainScreen/styles/webDrawersStyle.dart';
import 'package:social_co2/models/IndexProvider.dart';

class WebAdaptativeMainScreen extends StatefulWidget {
  const WebAdaptativeMainScreen({super.key});

  @override
  State<WebAdaptativeMainScreen> createState() =>
      _WebAdaptativeMainScreenState();
}

class _WebAdaptativeMainScreenState extends State<WebAdaptativeMainScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    return ChangeNotifierProvider(
        create: (_) => IndexProvider(),
        builder: (context, child) {
          return Scaffold(
              body: Row(
            children: [
              Container(
                decoration: const BoxDecoration(gradient: drawerBackground),
                child: SizedBox(
                  width: 300,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(right: 20),
                      itemCount: drawerEntries.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          // Si l'index est égal à 0, alors on affiche le logo de l'application
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            child: const Text(
                              "SCO2",
                              style: TextStyle(fontSize: 70),
                            ),
                          );
                        } else {
                          return Container(
                            // Puis on affiche les autres options du menu
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: drawerTileShadow,
                            child: ListTile(
                              onTap: () {
                                Provider.of<IndexProvider>(context,
                                        listen: false)
                                    .setSelectedIndex(index);
                              },
                              title: Text(
                                drawerEntries[index][0],
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                              leading: Icon(drawerEntries[index][1]),
                              iconColor: Colors.black,
                              textColor: Colors.black,
                            ),
                          );
                        }
                      }),
                ),
              ),
              Container(
                  decoration:
                      const BoxDecoration(color: Color.fromARGB(100, 0, 0, 0)),
                  child: Consumer<IndexProvider>(
                    builder: (context, value, child) {
                      return Text('index: ${value.selectedIndex}');
                    },
                  ))
            ],
          ));
        });
  }
}
