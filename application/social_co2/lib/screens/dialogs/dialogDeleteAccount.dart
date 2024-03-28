import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// TODO : Implémenter la requette de suppression de compte

class dialogDeleteAccount extends StatefulWidget {
  const dialogDeleteAccount({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _dialogDeleteAccount();
}

class _dialogDeleteAccount extends State<dialogDeleteAccount> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete),
      title: const Text("Supprimer le compte"),
      content: const Text(
          "Voulez-vous supprimer votre compte et toute ses données associés (dans un délai de 30 jours) ?"),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      actions: [
        if (!loading)
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
        if (!loading)
          ElevatedButton(
              onPressed: () => deleteAccount(),
              child: const Text("Supprimer le compte"))
      ],
    );
  }

  void deleteAccount() {
    setState(() {
      loading = true;
    });

    FirebaseAuth.instance.currentUser!.delete().then((value) {
      Navigator.pop(context);
    }).catchError((err) {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          showCloseIcon: true,
          closeIconColor: Colors.white,
          content: Text(
            'Erreur lors de la suppresion du compte : $err',
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
}
