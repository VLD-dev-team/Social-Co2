import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/LeaderboardProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

class LeaderBoardWidget extends StatefulWidget {
  final int indexAffichage; // Ajout d'un paramètre pour l'index d'affichage
  const LeaderBoardWidget({Key? key, required this.indexAffichage}) : super(key: key); //on indique que la variable indexAffichage est requise pour construire le widget

  @override
  State<LeaderBoardWidget> createState() => _LeaderBoardWidgetState();
}

class _LeaderBoardWidgetState extends State<LeaderBoardWidget> {
  String selectedIcon = 'world'; //On crée une variable pour afficher le classement monde ou des amis en la mettant sur monde par défaut


  @override
  Widget build(BuildContext context) {
    switch (widget.indexAffichage) {      //en fonnction de la valeur de indexAffichage, fournie à l'appel du widget, on renverra le widget correspondant
      case 1:
        return buildAffichagePourIndex1(); // Affichage pour l'index 1, petit sur HomeScreen
      case 2:
        return buildAffichagePourIndex2(); // Affichage pour l'index 2, moyen en format portrait sur LeaderBoardScreen
      case 3:
        return buildAffichagePourIndex3(); // Affichage pour l'index 3, grand sur LeadderBoardScreen
      default:
        return buildAffichageParDefaut(); // Affichage par défaut si aucun index ou index non géré, renvoie une erreur
    }
  }

  Widget buildAffichagePourIndex1() {
    // contenu spécifique pour l'index 1
    return Container(
      width: double.maxFinite,    //largeur du widget
      height: 600,              //hauteur du widget
      decoration: primaryCard,    //style du widget
      child: Column(            //On déclare un format colmun pour pouvoir mettre plusieurs widget les uns sur les autres
        crossAxisAlignment: CrossAxisAlignment.center, //On centre les widgets dans la colonne
        children: [
          const SizedBox(         //widget qui permet d'adapter la taille
            width: 250,         //largeur de la sizedbox
            child: Card(          //Widget Card dans le widget SizedBox qui contiendra le titre
              margin: EdgeInsets.all(10.0),  
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Center(
                  child: Text(
                    "Leaderboard",    //titre
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), //arrondir les bords de la Card
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(  //permet de detecter quand l'utilisateur clic sur l'icone monde
                    onTap: () {
                      setState(() {
                        selectedIcon = 'world'; //Dans ce cas on donne la valeur world au selectedIcon
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
                  GestureDetector( //permet de detecter quand l'utilisateur clic sur l'icone amis
                    onTap: () {
                      setState(() {
                        selectedIcon = 'friends';  //Dans ce cas on donne la valeur friends au selectedIcon
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
            child: selectedIcon=="world"?  //on teste la condition 
            const Card(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Monde",style: TextStyle(fontSize: 25),), //si elle est vraie on affiche World
            ),) 
            : const Card(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Amis",style: TextStyle(fontSize: 25),), //Sinon on affiche Amis
            ),),
          ),
          Consumer<LeaderBoardProvider>(            //permet d'importer les données que nous fourni le provider
              builder: ((context, value, child) {

                
            if (value.isLoading) {          //affichage du charment
              return const SizedBox(
                height: 40,
                child: LinearProgressIndicator(),
              );
            } else {
              if (value.error == "") {        //s'il n'y a pas d'erreur on affiche la liste (le classement)
                return SizedBox(
                  height: 420,
                  child: ListView.builder(
                      itemCount: 10,      //Nombre de lignes dans le classement
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: const EdgeInsets.all(2),
                          decoration: primaryCard,
                          child: Card(
                            child: Container(
                              decoration: secondaryCardInnerShadow,
                              child: ListTile(            //le widget ListTile décrit la construction d'une ligne de la liste, et se répéte le nombre d'itemCount
                                leading: CircleAvatar(               //Affiche un rond qui contient le classement
                                  backgroundColor: Colors.white,
                                  child: Text('${index + 1}e', //classement
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: 
                                      index == 0 ? const Color.fromRGBO(255, 170, 43, 1) 
                                      : index == 1 ? const Color.fromRGBO(217, 217, 217, 1)       //couleur du classement
                                      : index ==2 ? const Color.fromRGBO(255, 107, 0, 1)
                                      : Colors.black),
                                  ), 
                                ),
                                title: Row(
                                  children: [
                                    const CircleAvatar(         //affiche un rond qui contient la photo de profil de l'utilisateur
                                      backgroundColor: Color.fromRGBO(157, 188, 150, 1),
                                      child: Icon(
                                        Icons.account_circle_outlined,          //TODO : à remplacer par la photo de profil
                                        size: 40,
                                        ),    
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
              } else { //gestion de l'erreur
                return SizedBox(
                  child: Text(value.error), //si il y'a une erreur on renvoie l'erreur
                );
              }
            }
          })),
        ],
      ),
    );
  }

  Widget buildAffichagePourIndex2() { //affichage pour l'index 2
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
                                    Icons.account_circle_outlined,   //TODO à remplacer
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

  Widget buildAffichagePourIndex3() { //affichage pour l'index 3
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Container(
      width: MediaQuery.of(context).size.width - 340,  //on prend la largeur de la page - la largeur du burger
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
                  listLeaderbaord("Monde", MediaQuery.of(context).size.width / 2 - getDrawerWidth(context) / 2 - 40), //ici on appelle le widget listLeaderBoard qui nous fournira le classement, avec comme paramètre le type de classement et la largeur
                  const VerticalDivider(
                    color: Colors.white,
                    width: 20,                  //barre blanche entre les 2 classements
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

