import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/IndexProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class ScoreQuickOverview extends StatefulWidget {
  @override
  State<ScoreQuickOverview> createState() => _ScoreQuickOverviewState();
}

class _ScoreQuickOverviewState extends State<ScoreQuickOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: primaryCard,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Table(children: [
          TableRow(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: secondaryCardInnerShadow,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Card(
                            margin: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                "Aujourdhui",
                                style: TextStyle(fontSize: 25),
                              ),
                            )),
                        Card(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          color: primaryCardColor,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                "Lorem IPSUjejzfzefnjzfnjdfkjdfnkjdfgnkjdfgnkdjfgnkjdfgkdjfngkjdfngkjdfngkjdfngkdfjngkdfjgnkdfjgnkdjfgnkdfjgkdfjgkdjfgnkdfsjgksdjfgnkdfjgndfjkgndkjfs"),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: secondaryCardInnerShadow,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Card(
                            margin: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                "Hier",
                                style: TextStyle(fontSize: 25),
                              ),
                            )),
                        Card(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          color: primaryCardColor,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                "Lorem IPSUjejzfzefnjzfnjdfkjdfnkjdfgnkjdfgnkdjfgnkjdfgkdjfngkjdfngkjdfngkjdfngkdfjngkdfjgnkdfjgnkdjfgnkdfjgkdfjgkdjfgnkdfsjgksdjfgnkdfjgndfjkgndkjfs"),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.fill,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 5),
                  child: Container(
                    margin: EdgeInsets.zero,
                    decoration: secondaryCardInnerShadow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: primaryCard,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                      "Votre score",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                                Card(
                                  color: secondaryCardColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                      '- ${Provider.of<IndexProvider>(listen: false, context).selectedIndex.toString()} SCO -',
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: primaryCard,
                          height: 150,
                          child: GridView.count(
                            crossAxisCount: 6,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [Text("data")],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [Text("data")],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [Text("data")],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [Text("data")],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [Text("data")],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [Text("data")],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ]),
        ]),
      ),
    );
  }
}
