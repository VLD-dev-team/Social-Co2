import 'package:flutter/material.dart';
import 'package:social_co2/screens/widgets/LeaderBoardWidget.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/styles/MainScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class LeaderBoardScreeen extends StatelessWidget {
  const LeaderBoardScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveFormats responsiveFormat = whichResponsiveFormat(context);
    int drawerWidth = getDrawerWidth(context);

    return Container(
      decoration: homeScreenBackground,
      height: double.infinity,
      width: MediaQuery.of(context).size.width - drawerWidth,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Container(
          decoration: primaryCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Card(
                child: Center(
                  child: Text(
                    "Leaderboard",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Container(
                decoration: secondaryCardInnerShadow,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Card(
                            child:
                                Text("Mondial", style: TextStyle(fontSize: 25)),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 10,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Card(
                            child: Text("Amis", style: TextStyle(fontSize: 25)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
