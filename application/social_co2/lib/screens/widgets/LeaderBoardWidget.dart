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
            if (value.isLoading) {          //affichage du charment
              return const SizedBox(
                height: 40,
                child: LinearProgressIndicator(),
              );
            } else {
              if (value.error == "") {        //gestion de l'erreur
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: ((context, index) {
                        return Container(
                          decoration: primaryCard,
                          child: Card(
                            child: Container(
                              decoration: secondaryCardInnerShadow,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text('${index + 1}e',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: 
                                      index == 0 ? const Color.fromRGBO(255, 170, 43, 1) 
                                      : index == 1 ? const Color.fromRGBO(217, 217, 217, 1) 
                                      : index ==2 ? const Color.fromRGBO(255, 107, 0, 1)
                                      : Colors.black),
                                  
                                  ),     //affichage postion classement
                                ),
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text("icon"),          //affichage icone utilisateur
                                    ),
                                    Expanded(child: Center(child: Text(
                                      "Username",
                                      style: TextStyle(fontSize:25 ),
                                      ))),  //affichage pseudo utilisateur                           //TODO : remplacer par vraies valeurs
                                    Text('${index + 5000 }',
                                    style: TextStyle(fontSize:25 ),),  
                                  ],
                                ),
                              ),
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
