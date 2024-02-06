// Importation des packages requis pour flutter
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Importation des préférences firebase pour l'authentification ainsi que des packages firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'firebase_options.dart';

// Importation du screen de page d'accueil
import 'screens/homeScreen.dart';

// Déclaration des variables Firebase
late final FirebaseApp firebaseApp;
late final FirebaseAuth firebaseAuth;

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Vérification que l'initialisation des composants de l'application ont été effectués avant d'initialiser firebase
  firebaseApp = await Firebase.initializeApp(
    // Initialisation de firebase avec le fichier de configuration généré par la CLI flutterfire
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  if (!kIsWeb) {
    await GoogleSignInDart.register(
      clientId:
          '741858065565-c6flb27i9du2l9qp31hj025l9scomiqp.apps.googleusercontent.com',
    );
  }

  runApp(const MyApp()); // Lancement de l'application avec la class MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Définition des variables statiques globales
  static const String appName = 'SCO2';

  // Widget à la racine de l'application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: appName),
    );
  }
}
