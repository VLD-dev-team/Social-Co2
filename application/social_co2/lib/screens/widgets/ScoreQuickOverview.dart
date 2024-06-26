import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/providers/UserSCO2DataProvider.dart';
import 'package:social_co2/screens/dialogs/dialogNewActivity.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/styles/ScoreColors.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class ScoreQuickOverview extends StatefulWidget {
  const ScoreQuickOverview({super.key});

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
    ResponsiveFormats responsiveFormat = whichResponsiveFormat(context);

    return Container(
      decoration: primaryCard,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: (responsiveFormat != ResponsiveFormats.mobile)
            ? Table(children: [
                TableRow(children: [
                  const SQOLeftColumn(),
                  SQORightColumn(arrowScaleIndicator: arrowScaleIndicator)
                ]),
              ])
            : Table(
                children: [
                  TableRow(children: [
                    SQORightColumn(arrowScaleIndicator: arrowScaleIndicator)
                  ]),
                  const TableRow(children: [SQOLeftColumn()]),
                ],
              ),
      ),
    );
  }
}

class SQOLeftColumn extends StatelessWidget {
  const SQOLeftColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // controller de la date courante
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // controller de la date d'hier
    DateTime yesterday = today.subtract(const Duration(days: 1));

    return Consumer<UserActivitiesProvider>(
      builder: (context, value, child) => TableCell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: secondaryCardInnerShadow,
              child: (!value.isLoading)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (value.error == '')
                          ? [
                              const Card(
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
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                color: primaryCardColor,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        '${value.userRecapPhrasePerDays[today]}')),
                              ),
                            ]
                          : [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'Une erreur est survenue\n${value.error}',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ])
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
              child: (!value.isLoading)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (value.error == '')
                          ? [
                              const Card(
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
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                color: primaryCardColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                      '${value.userRecapPhrasePerDays[yesterday]}'),
                                ),
                              ),
                            ]
                          : [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'Une erreur est survenue\n${value.error}',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ])
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: FilledButton.icon(
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15)),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                      showDialog(
                              context: context,
                              builder: (context) => const newActivityDialog())
                          .then((value) => Provider.of<UserActivitiesProvider>(
                                  context,
                                  listen: false)
                              .initData());
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Ajouter une activité",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class SQORightColumn extends StatelessWidget {
  const SQORightColumn({
    super.key,
    required this.arrowScaleIndicator,
  });

  final Widget arrowScaleIndicator;

  @override
  Widget build(BuildContext context) {
    ResponsiveFormats responsiveFormat = whichResponsiveFormat(context);

    return Consumer<UserSCO2DataProvider>(
      builder: (context, ProviderValues, child) => TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: (responsiveFormat != ResponsiveFormats.mobile)
                ? const EdgeInsets.only(left: 10, bottom: 5)
                : const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 0),
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
                                  child: ((ProviderValues.isLoading == false) &&
                                          (ProviderValues.error == ""))
                                      ? Text(
                                          '- ${ProviderValues.CurrentUserScore} SCO -',
                                          style: const TextStyle(fontSize: 25),
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
                          child: (ProviderValues.error == "")
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Visibility(
                                          visible: ProviderValues
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
                                                          Radius.circular(15),
                                                      bottomRight: Radius.zero,
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15))),
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
                                        Visibility(
                                          visible: ProviderValues
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
                                        Visibility(
                                          visible: ProviderValues
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
                                        Visibility(
                                          visible: ProviderValues
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
                                        Visibility(
                                          visible: ProviderValues
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
                                                      bottomLeft: Radius.zero,
                                                      bottomRight:
                                                          Radius.circular(15),
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
                                  ],
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Une erreur est survenue\n${ProviderValues.error}',
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
          )),
    );
  }
}
