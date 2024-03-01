import 'package:flutter/material.dart';
import 'package:social_co2/styles/CardStyles.dart';

class ScoreQuickOverview extends StatefulWidget {
  @override
  State<ScoreQuickOverview> createState() => _ScoreQuickOverviewState();
}

class _ScoreQuickOverviewState extends State<ScoreQuickOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryCardColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
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
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.zero,
                decoration: secondaryCardInnerShadow,
                child: Text('dada'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
