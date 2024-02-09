// Importation des packages requis pour flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Importation des préférences firebase pour l'authentification ainsi que des packages firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

// Importation du screen de page d'accueil et de l'écran de connexion/création de compte
import 'screens/homeScreen.dart';
import 'package:social_co2/screens/authScreen.dart';

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

  // Instanciation de firebase Auth (gestionnaire de compte utilisateurs)
  firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
  // TODO : à voir si c'est utile à l'avenir étant donné qu'on a un stream en dessous
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  // Vérification du type de client
  // Google Signin étant initialisé automatiquement uniquement sur les pages web
  /* if (!kIsWeb) {
    // On initialise Google Signin manuellement sur les clients autre que Web
    await GoogleSignInDart.register(
      clientId:
          '741858065565-c6flb27i9du2l9qp31hj025l9scomiqp.apps.googleusercontent.com',
    );
  } */

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
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        // Initilisation du streamBuilder pour surveiller si l'utilisateur est connecté ou non
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          // Construction de l'écran d'accueil ou l'écran d'authentification en fonction du statut de connexion
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
