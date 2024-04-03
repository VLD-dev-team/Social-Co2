import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/LeaderboardProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class LeaderBoardWidget extends StatefulWidget {
  final int indexAffichage; // Ajout d'un paramètre pour l'index d'affichage
  const LeaderBoardWidget({Key? key, required this.indexAffichage}) : super(key: key);

  @override
  State<LeaderBoardWidget> createState() => _LeaderBoardWidgetState();
}

class _LeaderBoardWidgetState extends State<LeaderBoardWidget> {
  String selectedIcon = 'world';


  @override
  Widget build(BuildContext context) {
    // Utilisation d'un switch pour gérer les différents affichages basés sur indexAffichage
    switch (widget.indexAffichage) {
      case 1:
        return buildAffichagePourIndex1(); // Affichage pour l'index 1
      case 2:
        return buildAffichagePourIndex2(); // Affichage pour l'index 2
      case 3:
        return buildAffichagePourIndex3(); // Affichage pour l'index 3
      default:
        return buildAffichageParDefaut(); // Affichage par défaut si aucun index ou index non géré
    }
  }

  Widget buildAffichagePourIndex1() {
    // contenu spécifique pour l'index 1
    return Container(
      width: double.maxFinite,
      height: 600,
      decoration: primaryCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 250,
            child: Card(
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
          ),
          SizedBox(
            width: 100,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = 'world';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2), // Ajoute de l'espace autour de l'icône
                      decoration: BoxDecoration(
                        color: selectedIcon == 'world' ? const Color.fromARGB(100, 150, 150, 150) : Colors.transparent, // Fond gris si sélectionné
                        borderRadius: BorderRadius.circular(100), // Bord arrondi
                      ),
                      child: const Icon(
                        Icons.public_rounded,
                        size: 30,
                        color: Colors.black, // Couleur de l'icône
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = 'friends';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2), // Ajoute de l'espace autour de l'icône
                      decoration: BoxDecoration(
                        color: selectedIcon == 'friends' ?  const Color.fromARGB(100, 150, 150, 150) : Colors.transparent, // Fond gris si sélectionné
                        borderRadius: BorderRadius.circular(100), // Bord arrondi
                      ),
                      child: const Icon(
                        Icons.people_alt_rounded,
                        size: 30,
                        color: Colors.black,
                    ),
                  ),
                  ),
                ]
              ),
            ),
          ),
          SizedBox(
            child: selectedIcon=="world"? 
            const Card(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Monde",style: TextStyle(fontSize: 25),),
            ),) 
            : const Card(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Amis",style: TextStyle(fontSize: 25),),
            ),),
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
                  height: 420,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: const EdgeInsets.all(2),
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
                                    const CircleAvatar(
                                      backgroundColor: Color.fromRGBO(157, 188, 150, 1),
                                      child: Icon(
                                        Icons.account_circle_outlined,
                                        size: 40,
                                        ),          //affichage icone utilisateur
                                    ),
                                     Expanded(
                                      child: Center(
                                        child: 
                                        
                                        Text(
                                      "Username$selectedIcon",                                         //value.leaderBoardFriends.leaderBoardData[index]['username'].toString()
                                      style: const TextStyle(fontSize:25 ),
                                      )
                                      )
                                      ),  //affichage pseudo utilisateur                           //TODO : remplacer par vraies valeurs
                                    Text('${index + 5000 }',
                                    style: const TextStyle(fontSize:25 ),),  
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

  Widget buildAffichagePourIndex2() {
    // contenu spécifique pour l'index 2
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        decoration: primaryCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 250,
              child: Card(
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
            ),
      
            SizedBox(
              width: 100,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = 'world';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2), // Ajoute de l'espace autour de l'icône
                        decoration: BoxDecoration(
                          color: selectedIcon == 'world' ? const Color.fromARGB(100, 150, 150, 150) : Colors.transparent, // Fond gris si sélectionné
                          borderRadius: BorderRadius.circular(100), // Bord arrondi
                        ),
                        child: const Icon(
                          Icons.public_rounded,
                          size: 30,
                          color: Colors.black, // Couleur de l'icône
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = 'friends';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2), // Ajoute de l'espace autour de l'icône
                        decoration: BoxDecoration(
                          color: selectedIcon == 'friends' ?  const Color.fromARGB(100, 150, 150, 150) : Colors.transparent, // Fond gris si sélectionné
                          borderRadius: BorderRadius.circular(100), // Bord arrondi
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          size: 30,
                          color: Colors.black,
                      ),
                    ),
                    ),
                  ]
                ),
              ),
            ),
      
            Container(
              
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height-150, 
        decoration: secondaryCardInnerShadow,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: selectedIcon == "world"
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Monde",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                )
              : const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Amis",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
        ),
        Expanded(
          child: Consumer<LeaderBoardProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return const SizedBox(
                  height: 40,
                  child: LinearProgressIndicator(),
                );
              } else if (value.error == "") {
                return ListView.builder(
                  itemCount: 30, 
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: secondaryCardInnerShadow,
                      child: Card(
                        child: Container(
                          decoration: primaryCard,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                '${index + 1}e',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: index == 0
                                      ? const Color.fromRGBO(255, 170, 43, 1)
                                      : index == 1
                                          ? const Color.fromRGBO(217, 217, 217, 1)
                                          : index == 2
                                              ? const Color.fromRGBO(255, 107, 0, 1)
                                              : Colors.black,
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color.fromRGBO(157, 188, 150, 1),
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    size: 40,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Username$selectedIcon", // TODO a remplacer
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${index + 5000}',
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return SizedBox(
                  child: Text(value.error),
                );
              }
            },
          ),
        ),
      ],
        ),
      )])),
    );

  }

  Widget buildAffichagePourIndex3() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Container(
      width: MediaQuery.of(context).size.width - 340,
      decoration: primaryCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 250,
            child: Card(
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
          ),
          Expanded( 
            child: Container(
              decoration: secondaryCardInnerShadow,
              margin: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  listLeaderbaord("Monde", MediaQuery.of(context).size.width / 2 - getDrawerWidth(context) / 2 - 40),
                  const VerticalDivider(
                    color: Colors.white,
                    width: 20,
                    thickness: 10,
                  ),
                  listLeaderbaord("Amis", MediaQuery.of(context).size.width / 2 - getDrawerWidth(context) / 2 - 40),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget buildAffichageParDefaut() {
    // Contenu par défaut si aucun index spécifique n'est fourni ou reconnu
    return const Text("Erreur d'index");
  }
}


Widget listLeaderbaord(String title, double width) {
  return SizedBox(
    width: width,
    child: Column(
      children: [
        Center(
          child: SizedBox(
            width: 150,
            child: Card(
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Consumer<LeaderBoardProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return const SizedBox(
                  height: 40,
                  child: LinearProgressIndicator(),
                );
              } else if (value.error == "") {
                return ListView.builder(
                  itemCount: 30, 
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: secondaryCardInnerShadow,
                      child: Card(
                        child: Container(
                          decoration: primaryCard,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                '${index + 1}e',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: index == 0
                                      ? const Color.fromRGBO(255, 170, 43, 1)
                                      : index == 1
                                          ? const Color.fromRGBO(217, 217, 217, 1)
                                          : index == 2
                                              ? const Color.fromRGBO(255, 107, 0, 1)
                                              : Colors.black,
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color.fromRGBO(157, 188, 150, 1),
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    size: 40,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Username$title", // TODO a remplacer
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${index + 5000}',
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return SizedBox(
                  child: Text(value.error),
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}

