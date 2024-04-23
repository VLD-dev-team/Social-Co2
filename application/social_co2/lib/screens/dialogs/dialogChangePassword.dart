import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class dialogChangePassword extends StatefulWidget {
  const dialogChangePassword({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _dialogChangePassword();
}

class _dialogChangePassword extends State<dialogChangePassword> {
  bool loading = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.password),
      title: const Text('Changement de mot de passe'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            enabled: !loading,
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nouveau mot de passe.',
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      actions: [
        if (!loading)
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
        if (!loading)
          ElevatedButton(
              onPressed: () => changePassword(),
              child: const Text("Changer le mot de passe"))
      ],
    );
  }

  void changePassword() {
    setState(() {
      loading = true;
    });

    FirebaseAuth.instance.currentUser!
        .updatePassword(controller.text)
        .then((value) {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          showCloseIcon: true,
          closeIconColor: Colors.white,
          content: const Text(
            'Mot de passe modifié !',
            style: TextStyle(fontSize: 15),
          ),
          duration: const Duration(milliseconds: 3000),
          padding: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
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
            'Erreur lors de la modification du mot de passe : $err',
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
