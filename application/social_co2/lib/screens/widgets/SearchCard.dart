import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/FriendshipsProvider.dart';
import 'package:social_co2/providers/SearchProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class SearchCard extends StatefulWidget {
  const SearchCard({super.key});

  @override
  State<StatefulWidget> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  TextEditingController searchFieldController =
      TextEditingController(); // controller du champ de recherche
  bool resultsVisible = false; // Variable de visibilité des résultats
  Timer? _debounce; // Timer du debouncer pour le champ de recherche
  List sended =
      []; // Map qui enregistre temporairement quelle demande ont été envoyés dans la liste de résultats

  @override
  void dispose() {
    // Suppression du timer du debouncer si le widget est supprimé
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      // Initialisation du provider pour la recherche
      builder: (context, SearchProviderValues, child) => Container(
        margin: const EdgeInsets.all(10),
        decoration: primaryCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
                margin: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "Rechercher un utilisateur",
                    style: TextStyle(fontSize: 25),
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 0, bottom: 10),
              decoration: const BoxDecoration(
                  color: secondaryCardColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  minLines: 1,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      hintText: "Tapez ici un nom d'utilisateur"),
                  controller: searchFieldController,
                  onChanged: (value) {
                    // A chaque changement de caractère dans le champ de texte, on appelle la fonction de recherche
                    // avec un deboucer pour éviter d'atteindre la ratelimit du serveur
                    setState(() {
                      resultsVisible = (value != "");
                    });
                    if (value != "") {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        SearchProviderValues.search(value);
                      });
                    }
                  },
                ),
              ),
            ),
            Visibility(
              visible: resultsVisible,
              child: SizedBox(
                height: 300,
                child: (SearchProviderValues.searching)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : (SearchProviderValues.searchResults.isNotEmpty)
                        ? ListView.separated(
                            itemBuilder: (context, index) {
                              final result =
                                  SearchProviderValues.searchResults[index];
                              return resultTile(result);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 5),
                            itemCount:
                                SearchProviderValues.searchResults.length)
                        : const Center(
                            child: Text('Pas de résultats'),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile resultTile(result) {
    result['name'] ??= "Nom inconnu";
    return ListTile(
      title: Text(result['name']),
      subtitle: Text('ID : ${result['uid']}'),
      leading: SizedBox(
        width: 45,
        height: 45,
        child: CircleAvatar(
          radius: 360,
          backgroundImage: (result['photoURL'] == null)
              ? null
              : NetworkImage('${result['photoURL']}'),
          backgroundColor: Colors.green,
          child: (result['photoURL'] == null)
              ? const Icon(Icons.account_box)
              : null,
        ),
      ),
      trailing: Consumer<FriendshipsProvider>(
        builder: (context, value, child) => OutlinedButton.icon(
            onPressed: (sended.contains(result['uid']))
                ? () {
                    setState(() {
                      sended.add(result['uid']);
                    });
                    value
                        .sendFriendRequest(result['uid'])
                        .then((value) => null)
                        .catchError((error) {
                      setState(() {
                        sended.remove(result['uid']);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                          closeIconColor: Colors.white,
                          content: Text(
                            "Erreur lors de l'envoie de la demande : $error",
                            style: const TextStyle(fontSize: 15),
                          ),
                          duration: const Duration(milliseconds: 3000),
                          padding: const EdgeInsets.all(20),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                    });
                  }
                : null,
            icon: const Icon(Icons.person_add),
            label: const Text("Demander en ami(e)")),
      ),
    );
  }
}
