import 'package:flutter/material.dart';
import 'package:social_co2/styles/CardStyles.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({super.key});

  @override
Widget build(BuildContext context) {
  return TableCell(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: secondaryCardInnerShadow,
          child: Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Center(
                child: Container( 
                  child: Text(
                    "Leaderboard",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
