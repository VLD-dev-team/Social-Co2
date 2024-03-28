import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class dialogChangeDisplayName extends StatefulWidget {
  const dialogChangeDisplayName({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _dialogChangeDisplayName();
}

class _dialogChangeDisplayName extends State<dialogChangeDisplayName> {
  bool loading = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.edit),
      title: const Text('Changer de nom public'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            enabled: !loading,
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nouveau nom.',
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
              onPressed: () => changeDisplayName(),
              child: const Text("Changer de nom public"))
      ],
    );
  }

  void changeDisplayName() {
    setState(() {
      loading = true;
    });

    FirebaseAuth.instance.currentUser!
        .updateDisplayName(controller.text)
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
            'Nom modifié !',
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
            'Erreur lors de la modification du nom public : $err',
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
