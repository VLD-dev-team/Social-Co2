import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/IndexProvider.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/providers/UserSCO2DataProvider.dart';
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
            TableCell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: secondaryCardInnerShadow,
                    child: (!Provider.of<UserActivitiesProvider>(context)
                            .isLoading)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                (Provider.of<UserActivitiesProvider>(context)
                                            .error ==
                                        '')
                                    ? const [
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
                                          margin: EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          color: primaryCardColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                                "Lorem IPSUjejzfzefnjzfnjdfkjdfnkjdfgnkjdfgnkdjfgnkjdfgkdjfngkjdfngkjdfngkjdfngkdfjngkdfjgnkdfjgnkdjfgnkdfjgkdfjgkdjfgnkdfsjgksdjfgnkdfjgndfjkgndkjfs"),
                                          ),
                                        ),
                                      ]
                                    : [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              'Une erreur est survenue\n${Provider.of<UserActivitiesProvider>(context).error}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ])
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: secondaryCardInnerShadow,
                    child: (!Provider.of<UserActivitiesProvider>(context)
                            .isLoading)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                (Provider.of<UserActivitiesProvider>(context)
                                            .error ==
                                        '')
                                    ? const [
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
                                          margin: EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          color: primaryCardColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                                "Lorem IPSUjejzfzefnjzfnjdfkjdfnkjdfgnkjdfgnkdjfgnkjdfgkdjfngkjdfngkjdfngkjdfngkdfjngkdfjgnkdfjgnkdjfgnkdfjgkdfjgkdjfgnkdfsjgksdjfgnkdfjgndfjkgndkjfs"),
                                          ),
                                        ),
                                      ]
                                    : [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              'Une erreur est survenue\n${Provider.of<UserActivitiesProvider>(context).error}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ])
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 5),
                  child: Container(
                    decoration: secondaryCardInnerShadow,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
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
                                        child: (!Provider.of<
                                                            UserSCO2DataProvider>(
                                                        context)
                                                    .isLoading &&
                                                Provider.of<UserSCO2DataProvider>(
                                                            context)
                                                        .error !=
                                                    "")
                                            ? Text(
                                                '- ${Provider.of<UserSCO2DataProvider>(context).CurrentUserScore.toString()} SCO -',
                                                style: const TextStyle(
                                                    fontSize: 25),
                                              )
                                            : const Text(
                                                '- **** SCO -',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              decoration: tertiaryCard,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: (Provider.of<UserSCO2DataProvider>(
                                                context)
                                            .error ==
                                        "")
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: Provider.of<
                                                                UserSCO2DataProvider>(
                                                            listen: false,
                                                            context)
                                                        .CurrentUserScoreScale ==
                                                    1,
                                                child: arrowScaleIndicator,
                                              ),
                                              Container(
                                                height: 100,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: scoreColorA,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.zero,
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: Provider.of<
                                                                UserSCO2DataProvider>(
                                                            listen: false,
                                                            context)
                                                        .CurrentUserScoreScale ==
                                                    2,
                                                child: arrowScaleIndicator,
                                              ),
                                              Container(
                                                height: 85,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: scoreColorB,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.zero,
                                                            bottomRight:
                                                                Radius.zero,
                                                            topLeft:
                                                                Radius.zero,
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: Provider.of<
                                                                UserSCO2DataProvider>(
                                                            listen: false,
                                                            context)
                                                        .CurrentUserScoreScale ==
                                                    3,
                                                child: arrowScaleIndicator,
                                              ),
                                              Container(
                                                height: 70,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: scoreColorC,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.zero,
                                                            bottomRight:
                                                                Radius.zero,
                                                            topLeft:
                                                                Radius.zero,
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: Provider.of<
                                                                UserSCO2DataProvider>(
                                                            listen: false,
                                                            context)
                                                        .CurrentUserScoreScale ==
                                                    4,
                                                child: arrowScaleIndicator,
                                              ),
                                              Container(
                                                height: 55,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: scoreColorD,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.zero,
                                                            bottomRight:
                                                                Radius.zero,
                                                            topLeft:
                                                                Radius.zero,
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: Provider.of<
                                                                UserSCO2DataProvider>(
                                                            listen: false,
                                                            context)
                                                        .CurrentUserScoreScale ==
                                                    5,
                                                child: arrowScaleIndicator,
                                              ),
                                              Container(
                                                height: 40,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: scoreColorE,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.zero,
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                            topLeft:
                                                                Radius.zero,
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
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
                                        ],
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Text(
                                            'Une erreur est survenue\n${Provider.of<UserSCO2DataProvider>(context).error}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ))
          ]),
        ]),
      ),
    );
  }
}
