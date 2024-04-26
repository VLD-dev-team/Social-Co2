// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_co2/styles/CardStyles.dart';

// Définition des deux modes : connexion ou création de compte
enum AuthTypes { signin, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Définition des variables globales et des controlleurs pour le form
  AuthTypes currentAuthType = AuthTypes.signin;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pswInputController = TextEditingController();
  String error = "";
  bool isLoading = false;

  // Définition du toast d'affichage des erreurs
  void displayError(String errorMessage) {
    setState(() {
      error = errorMessage;
    });
  }

  // Définition de la fonction qui change le type d'authentification
  void changeAuthType() {
    setState(() {
      if (currentAuthType == AuthTypes.signin) {
        currentAuthType = AuthTypes.signup;
      } else {
        currentAuthType = AuthTypes.signin;
      }
    });
  }

  void loading(visibility) {
    setState(() {
      isLoading = visibility;
    });
  }

  // Fonction de connexion avec Email et mot de passe
  void signin() async {
    loading(true); // Affichage du ModalBottomSheet de chargement
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        // Tentative de connexion avec Email et mot de passe
        email: emailInputController.text,
        password: pswInputController.text,
      );
    } on FirebaseAuthException catch (e) {
      // En cas d'erreur, disparition du ModalBottomSheet de chargement et affichage de l'erreur en haut de l'écran
      loading(false);
      if (e.code == 'user-not-found') {
        displayError("Compte non trouvé.");
      } else if (e.code == 'wrong-password') {
        displayError('Mot de passe incorrect');
      } else if (e.code == 'invalid-credential') {
        displayError("Email ou mot de passe invalide");
      } else {
        displayError(e.code);
      }
    }
  }

  // Fonction de création de compte par Email et mot de passe
  void signup() async {
    loading(true); // Affichage du ModalBottomSheet de chargement
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        // Tentative de création de compte
        email: emailInputController.text,
        password: pswInputController.text,
      );
      await credential.user?.updateDisplayName(
          nameInputController.text); // Mise à jour du nom du profil
      loading(false);
    } on FirebaseAuthException catch (e) {
      // En cas d'erreur, disparition du ModalBottomSheet de chargement et affichage de l'erreur en haut de l'écran
      loading(false);
      if (e.code == 'weak-password') {
        displayError("Mot de passe trop faible");
      } else if (e.code == 'email-already-in-use') {
        displayError("Email déjà utilisé");
      }
    } catch (e) {
      loading(false);
      displayError(e.toString());
    }

    loading(false);
  }

  // Fonction de création de compte/connexion avec Google
  Future<UserCredential> signInWithGoogle() async {
    // On initialise google auth de manière différente sur le web ou sur android/ios
    if (kIsWeb) {
      // Si l'application est un site web
      // Démarrage de l'authentification google avec un fournisseur
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Obtention des droits d'accès à l'email et le profil du compte google
      googleProvider.addScope('profile').addScope('email');

      print(googleProvider);

      // Tentative de connexion avec les credentials
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Si l'application est sur Android ou Ios
      // Démarrage de l'authentification google

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtention des détails de l'utilisateurs
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Création des crédentials (identifiants et mot de passe)
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Tentative de connexion avec les credentials
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ajut d'un gesture detector pour enlever le focus sur les champs de texte quand l'utilisateur clique ailleurs
      onTap: () {
        FocusScope.of(context).unfocus;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar:
        PreferredSize(
          preferredSize: const Size.fromHeight(100), 
          child: 
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 100,
            title: Image.asset("logos/LOGO_SCO2.png"),
        ),),
        
        body:
            Container(
              //ajout de l'image de fond
              decoration: const BoxDecoration( 
        image: DecorationImage(
          image: AssetImage("images/jungle.png"),
          fit: BoxFit.cover,
        ),
      ),
              child: !isLoading // Affichage le form si aucune action d'authentication est en cours
                  ? Center(
                      child: SingleChildScrollView(
                          // Implémentation du scroll sur l'écran
                          child: SafeArea(
                              // Ajout d'une SafeArea pour contenir le formulaire de connexion/creation de compte
                              child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode
                            .onUserInteraction, // Automatisation de la validation du formulaire quand l'utilisateur entre des données
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Container(
                              decoration: primaryCard,
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (error != "")
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            error = "";
                                          });
                                        },
                                        tileColor: Colors.red,
                                        iconColor: Colors.white,
                                        title: const Text(
                                          "Échec de l'authentification",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          error,
                                          style:
                                              const TextStyle(color: Colors.white),
                                        ),
                                        leading: const Icon(Icons.close),
                                      ),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          (currentAuthType ==
                                                  AuthTypes
                                                      .signin) // Réglage du titre au dessus des champs pour informer du type d'authentification
                                              ? "Se connecter"
                                              : "Créer un compte",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Card(
                                      child: OutlinedButton.icon(
                                          onPressed: () {
                                            signInWithGoogle();
                                          },
                                          icon: Icon(Icons.web,color: Colors.black,),
                                          label: Text('Connexion avec Google',style: TextStyle(color: Colors.black),)),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    if (currentAuthType ==
                                        AuthTypes
                                            .signup) // En cas de création de compte, affichage du champ de texte pour définir le nom public du nouvel utilisateur
                                      Container(
                                        decoration: secondaryCardInnerShadow,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Card(
                                                child: TextFormField(
                                                  controller: nameInputController,
                                                  decoration: const InputDecoration(
                                                    hintText: '*Nom public',
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  autofillHints: const [
                                                    AutofillHints.newUsername
                                                  ], // Information nécessaire pour les éventuels services d'autocomplétion
                                                  keyboardType: TextInputType.text,
                                                  validator:
                                                      (value) => // TODO : Améliorer la validation de ce champ
                                                          value != null &&
                                                                  value.isNotEmpty
                                                              ? null
                                                              : 'Nom requis',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Container(
                                      decoration: secondaryCardInnerShadow,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              child: TextFormField(
                                                // Champ de texte pour l'email
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
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              child: TextFormField(
                                                controller: pswInputController,
                                                obscureText:
                                                    true, // On cache le mot de passe des regards indiscrets
                                                decoration: const InputDecoration(
                                                  hintText: '*Mot de passe',
                                                  border: OutlineInputBorder(),
                                                ),
                                                autofillHints: (currentAuthType ==
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (currentAuthType ==
                                        AuthTypes
                                            .signin) // Implémentation du bouton de création de compte / connexion
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: FilledButton(
                                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                                                onPressed: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    // On valide le formulaire, si il est valide, on lance la connexion
                                                    signin();
                                                  }
                                                },
                                                child: const Text('Connexion',style: TextStyle(color: Colors.black),)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text("Pas encore de compte ?"),
                                              TextButton(
                                                  onPressed:
                                                      changeAuthType, // Changement de type de connexion
                                                  child: const Text(
                                                      "Créer mon compte")),
                                            ],
                                          )
                                        ],
                                      ),
                                    if (currentAuthType == AuthTypes.signup)
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: FilledButton(
                                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                                                onPressed: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    // On valide le formulaire, si il est valide, on lance la connexion
                                                    signup();
                                                  }
                                                },
                                                child: const Text('Créer un compte',style: TextStyle(color: Colors.black),)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                  "Vous possédez déjà un compte ?"),
                                              TextButton(
                                                  onPressed:
                                                      changeAuthType, // Changement de type de connexion
                                                  child:
                                                      const Text("Se connecter")),
                                            ],
                                          )
                                        ],
                                      ),
                                  ]),
                            ),
                          ),
                        ),
                      ))),
                    )
                  :
                  // Affichage de l'écran de chargement
                  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          (currentAuthType == AuthTypes.signin)
                              ? const Text("Connexion en cours")
                              : const Text("Création de votre compte")
                        ],
                      ),
                    ),
            ),
      ),
    );
  }
}
