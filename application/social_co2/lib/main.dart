// Importation des packages requis pour flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// Importation des polices d'écriture
import 'package:google_fonts/google_fonts.dart';

// Importation des préférences firebase pour l'authentification ainsi que des packages firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/firebase_options.dart';

// Importation des providers
import 'package:social_co2/providers/IndexProvider.dart';
import 'package:social_co2/providers/MakePostProvider.dart';
import 'package:social_co2/providers/UserActivitiesProvider.dart';
import 'package:social_co2/providers/UserSCO2DataProvider.dart';

// Importation du screen de page d'accueil et de l'écran de connexion/création de compte
import 'package:social_co2/screens/authScreen.dart';
import 'package:social_co2/screens/adaptativeContainers/MobileAdaptativeContainer.dart';
import 'package:social_co2/screens/adaptativeContainers/WebAdaptativeContainer.dart';

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
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      print(token);
    }
  });

  usePathUrlStrategy(); // Optimisation des URL pour les navigateurs
  runApp(const Sco2()); // Lancement de l'application avec la class Sco2
}

class Sco2 extends StatelessWidget {
  const Sco2({super.key});

  // Définition des variables statiques globales
  static const String appName = 'SCO2';

  // Widget à la racine de l'application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        //useMaterial3: true,
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.readexProTextTheme(),
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

// Initialisation de la page d'accueil en fonction du type de clientS
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /* 
    Notre application doit pouvoir s'executer aussi bien en tant que site Web que comme une application Native
    Étant donné que la disposition de nos widgets est radicalement différente sur mobile ou sur web, 
    notre choix à été de partager le code en deux classe distincte avec deux états distincts
    Cependant, les composants graphiques de l'application seront appelés dans les deux classes, avec un design responsive
    */

    // On renvoie les providers necessaire aux passages de données dans les écrans
    return MultiProvider(
      providers: [
        ListenableProvider<IndexProvider>(
            create: (_) =>
                IndexProvider()), // Provider d'écran pour le selected_index
        ListenableProvider<UserActivitiesProvider>(
            create: (_) =>
                UserActivitiesProvider()), // Provider des activitiés de l'utilisateur courant
        ListenableProvider<UserSCO2DataProvider>(
            create: (_) =>
                UserSCO2DataProvider()), // Provider du score et des infos SCO2 de l'utilisateur courant
        ListenableProvider<MakePostProvider>(
            create: (_) =>
                MakePostProvider()), // Provider qui permet de poster des données
      ],
      builder: (context, child) {
        if (kIsWeb) {
          return WebAdaptativeContainer(); // Si le client est un navigateur web, on renvoie la classe correspondante
        } else {
          return const MobileAdaptativeContainer(); // Sinon , c'est une application native, on renvoie la classe correspondante
        }
      },
    );
  }
}
