import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/LeaderboardProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class LeaderBoardWidget extends StatelessWidget {
  const LeaderBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 300,
      decoration: primaryCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Center(
                child: Text(
                  "Leaderboard",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          Consumer<LeaderBoardProvider>(
              builder: ((context, value, child) {
            if (value.isLoading) {
              return const SizedBox(
                height: 40,
                child: LinearProgressIndicator(),
              );
            } else {
              if (value.error == "") {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: ((context, index) {
                        return Container(
                          decoration: secondaryCardInnerShadow,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text('${index + 1}e'),
                            ),
                          ),
                        );
                      })),
                );
              } else {
                return SizedBox(
                  child: Text(value.error),
                );
              }
            }
          })),
        ],
      ),
    );
  }
}
