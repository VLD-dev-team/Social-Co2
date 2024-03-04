import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/IndexProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/styles/ScoreColors.dart';

class ScoreQuickOverview extends StatefulWidget {
  @override
  State<ScoreQuickOverview> createState() => _ScoreQuickOverviewState();
}

class _ScoreQuickOverviewState extends State<ScoreQuickOverview> {
  Widget arrowScaleIndicator = Container(
    margin: const EdgeInsets.only(bottom: 10),
    width: 40,
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    child: const Center(
      child: Icon(Icons.expand_more_outlined),
    ),
  );

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: primaryCard,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            decoration: tertiaryCard,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //Visibility(child: arrowScaleIndicator, visible: Provider.of<(context),),
                                      Container(
                                        height: 100,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: scoreColorA,
                                            borderRadius: const BorderRadius
                                                    .only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight: Radius.zero,
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        child: const Center(
                                            child: Text(
                                          '1',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 85,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: scoreColorB,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft: Radius.zero,
                                                    bottomRight: Radius.zero,
                                                    topLeft: Radius.zero,
                                                    topRight:
                                                        Radius.circular(15))),
                                        child: const Center(
                                            child: Text(
                                          '2',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: scoreColorC,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft: Radius.zero,
                                                    bottomRight: Radius.zero,
                                                    topLeft: Radius.zero,
                                                    topRight:
                                                        Radius.circular(15))),
                                        child: const Center(
                                            child: Text(
                                          '3',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: scoreColorD,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft: Radius.zero,
                                                    bottomRight: Radius.zero,
                                                    topLeft: Radius.zero,
                                                    topRight:
                                                        Radius.circular(15))),
                                        child: const Center(
                                            child: Text(
                                          '4',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: scoreColorE,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft: Radius.zero,
                                                    bottomRight: Radius.zero,
                                                    topLeft: Radius.zero,
                                                    topRight:
                                                        Radius.circular(15))),
                                        child: const Center(
                                            child: Text(
                                          '5',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: scoreColorF,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft: Radius.zero,
                                                    bottomRight:
                                                        Radius.circular(15),
                                                    topLeft: Radius.zero,
                                                    topRight:
                                                        Radius.circular(15))),
                                        child: const Center(
                                            child: Text(
                                          '6',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ))
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
