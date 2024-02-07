import 'package:flutter/material.dart';

// Définition des deux modes : connexion ou création de compte
enum AuthTypes { signin, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Définition des variables globales et des controlleurs pour le form
  AuthTypes auth_type = AuthTypes.signin;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pswInputController = TextEditingController();

  // Définition du toast d'affichage des erreurs
  void displayError(String error, bool autoClose) {
    // TODO : Implémenter un toast message
    print(error);
  }

  // Définition de la fonction qui change le type d'authentification
  void changeAuthType() {
    setState(() {
      if (auth_type == AuthTypes.signin) {
        auth_type = AuthTypes.signup;
      } else {
        auth_type = AuthTypes.signin;
      }
    });
  }

  // TODO : implémenter la connexion à firebase
  void _login() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ajut d'un gesture detector pour enlever le focus sur les champs de texte quand l'utilisateur clique ailleurs
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('SCO2'), centerTitle: true),
        body: Center(
            child: SafeArea(
                // Ajout d'une SafeArea pour contenir le formulaire de connexion/creation de compte
                child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode
              .onUserInteraction, // Automatisation de la validation du formulaire quand l'utilisateur entre des données
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text((auth_type ==
                      AuthTypes
                          .signin) // Réglage du titre au dessus des champs pour informer du type d'authentification
                  ? "Se connecter"
                  : "Créer un compte"),
              if (auth_type ==
                  AuthTypes
                      .signup) // En cas de création de compte, affichage du champ de texte pour définir le nom public du nouvel utilisateur
                TextFormField(
                  controller: nameInputController,
                  decoration: const InputDecoration(
                    hintText: '*Nom public',
                    border: OutlineInputBorder(),
                  ),
                  autofillHints: const [
                    AutofillHints.newUsername
                  ], // Information nécessaire pour les éventuels services d'autocomplétion
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) => // TODO : Améliorer la validation de ce champ
                          value != null && value.isNotEmpty
                              ? null
                              : 'Email requis',
                ),
              TextFormField(
                // Champ de texte pour l'emai
                controller: emailInputController,
                decoration: const InputDecoration(
                  hintText: '*Adresse email',
                  border: OutlineInputBorder(),
                ),
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) => // TODO : Améliorer la validation de ce champ (rajouter une verif d'un @ par exemple)
                        value != null && value.isNotEmpty
                            ? null
                            : 'Email requis',
              ),
              TextFormField(
                controller: pswInputController,
                obscureText:
                    true, // On cache le mot de passe des regards indiscrets
                decoration: const InputDecoration(
                  hintText: '*Mot de passe',
                  border: OutlineInputBorder(),
                ),
                autofillHints: (auth_type ==
                        AuthTypes
                            .signin) // Informations nécessaires pour les éventuels services d'autocomplétion
                    ? const [AutofillHints.password]
                    : const [AutofillHints.newPassword],
                keyboardType: TextInputType.text,
                validator: (value) => value != null &&
                        value
                            .isNotEmpty // TODO : améliorer la validation de ce champ
                    ? null
                    : 'Mot de passe requis',
              ),
              FilledButton(
                  onPressed: _login,
                  child: const Text(
                      'Connexion')), // TODO : boutons de connexion par encore clairs ni fini, à implementer
              TextButton.icon(
                  onPressed: changeAuthType,
                  icon: const Icon(Icons.account_circle),
                  label: const Text("Créer mon compte"))
            ]),
          ),
        ))),
      ),
    );
  }
}
