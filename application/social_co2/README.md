[Accueil de la documentation](https://github.com/VLD-dev-team/Social-Co2/wiki)

# Social CO2 - Partie frontend Flutter

Bienvenue sur la documentation front-end du projet SCO2. Vous retrouverez ici les informations utiles pour comprendre le fonctionnement de l'application Flutter, son arboresence et sa procédure d'installation.

## Sommaire

* Couches de fonctionnement
* Arborescence des modules utilisés
    * Fichiers écrans (``screens``)
        * Conteneurs adaptatifs
        * Boites de dialogues
        * Ecran principaux
        * Widgets
    * Fichiers styles (``styles``)
    * Fichiers collections (`collections`)
    * Classes de données (`classes`)
    * Providers (`providers`)
    * Fonctions outils (`utils`)
* Installation
    * Configuration requises - Clés API - Mise en place
* Ressources supplémentaires
* Crédits

## Couches de fonctionnement

L'application flutter SCO2 repose sur trois couches de fonctionnement :
1. **Les conteneurs adaptatif :** Cette couche est composés de widgets et de fonctions qui permettent à l'application de s'adapter à toutes les plateformes et tailles d'écrans disponibles.
2. **Les widgets :** Cette couche est composés des widgets qui affichent les données, ainsi que de leurs fonctions locales.
3. **Les providers :** Cette couche est composée de classes de fonctions permettant d'effectuer les requêtes, de traiter les données et de stocker en mémoires les informations qui doivent l'être.

Ces trois couches intérragissent de la manière suivantes : 
- Au démarrage de l'application les conteneurs adaptatifs choisissent la disposition des widgets et initialisent les providers.
- Les providers effectues les premières requetes au serveur lors de leur initialisations et transmettent les données aux widgets à partir de ce instant jusqu'à la fin de l'execution de l'application. Ils peuvent être appelé à tout moments par les widgets à des fins d'actualisation ou d'envoi de données vers le serveur
- Les widgets sont affichés dans les classes adaptatives, et affiches les données stockés par les providers. Il est possible que des données soient stockés localement par les widgets mais elle sont généralement relatives au fonctionnement logique de celui-ci (index, onglet actif, etc)

## Arboresences des modules utilisés

    * Providers (`providers`)
    * Fonctions outils (`utils`)

### Fichiers écrans

Ces fichiers contiennent les widgets qui affichent les données et les conteneurs adaptatifs.

Les conteneurs adaptatifs sont dans les fichiers ``MobileAdaptativeContainer.dart`` et ``WebAdaptativeContainer.dart`` . Ils sont appelés par le fichier `main.dart` en fonction de la plateforme utilisée (site web ou application native). 

Les boites de dialogues utilisée dans l'application sont chacune disponible dans un fichier du dossier `/dialogs`.

Les fichiers dart contenus dans le dossier `/mainScreens` sont les écrans principaux de l'applications (accueil, rechercher, activités, etc). Ils contiennent les widgets d'affichage.

Les widgets spécifiques sont dans les fichiers dart du dossier `/widgets` . On y retrouve par exemple les widgets du leaderboard, ou encore du feed.

### Fichiers styles

Ces fichiers sont équivalent à des feuilles de styles en CSS. Ils contiennent des propriétés de style (colors, backgrounds, shadows). Ils sont appelés au cas par cas par les widgets qui en ont besoin.

### Fichiers collections

Ces fichiers contiennent des données statiques utiles au fonctionnement de l'application et aux requêtes. Comme la listes des activités disponibles, des mood disponibles, ou encore des modes de chauffages disponibles.

### Classes de données

Les fichiers de classes servent au provider et au widgets pour organiser et traiter des données en des instances de classe.

Plus concrétement, elles permettent d'unifier des ensembles de données possédants les même caractèristiques.

Par exemple, un post du feed contiendra toujours les même informations essentielles (le userid, un contenu texte, etc), nous le stockons et le traitons donc grâce à une instance de la classe de données ``SCO2Post``.

Chaque classe de données contient des caractèristiques propres, stockés dans des variables de classes (visible dans le constructeur de la classe). Certaines sont essentielles à l'instanciation (``required`` est alors visible à cotés d'entre elles dans le constucteur)

La plupart des classes possédent également une ou deux fonctions nécéssaires à l'instanciation et à l'envoie de l'instance au serveur:
- `fromJSON` : Cette fonction prend en entrés une réponse valide du serveur et transforme cet ensemble de données JSON en instance de la classe correspondante.
- `toJson` : Cette fonction permet de transformer une instance de classe en objet JSON recevable par le serveur via l'API.

### Providers

Les providers sont des fichiers dart spéciaux, ils sont les intermédiaires entre les widgets qui affichent les données et les classes de données. Ils sont chargés de stocker les données, leur état et effectuer les requêtes requises pour le fonctionnement de l'application.

Ils sont appelés par les widgets depuis leur initialisation dans le fichier main. Pour des raison d'arboresence de widgets pendant l'execution, ils sont aussi initialisé au cas pas cas dans les dialogbox. 

Ils contiennent généralement deux ou trois variables globales élémentaires : 
- `error`: Une chaine de caractère chargée de stocker les erreurs des requêtes (ex: Internal Server Error, ou Invalid Token)
- `loading` (ou isloading, posting, etc): Un booléen chargé d'informer les widgets si une requête est en cours d'execution, elle est placé à `true` si des données sont en cours de récéption ou d'envoi.

Les providers contiennent aussi dans des variables les données qu'ils sont chargés de traiter, c'est dans ceux-ci qu'elles sont stockés durant l'éxécution de l'application.

Par exemple pour le feed, le fichiers `FeedProvider.dart` contient les données du feed pendant l'execution dans la variable `feed` de type `List<SCO2post>`. Cette variable est vide à l'initialisation, puis est complété par les données du serveur par la fonction `getFeed()`.

Enfin les providers possédent des fonctions disponibles à l'executions à tout moment depuis les widgets `Consumer` et `Provider.of`. Elles effectues les requêtes et traitent les données quand elles sont appelés.

Pour finir, certains provider possèdent un constructeur pouvant faire appel à une ou plusieurs de leur fonction interne afin d'effectuer les requêtes au lancement de l'application ou à l'affichage d'un widget.
Ce constructeur est appelé lors de l'execution de la fonction `create` de certains widget.

Lors du traitement des données, les providers peuvent actualiser les widgets qui les écoutent grâce à la fonction `notifyListeners()`.

### Fonctions outils

Les fonctions outils sont disponibles dans le dossier `/utils` des fichiers sources. Elles servent à effectuer des actions spéciales.

- `enumDataParser`: les fonctions de ce fichiers servent à transformer des données `String` en instance de `Enum` et inversement. elles sont essentiels au traitement efficace des données et réduise le risque d'erreur de syntaxe lors des requêtes.

- `requestService.dart`: les fonctions de ce fichiers servent à effectuer les quatres types de requêtes http à l'api. On y retrouve les fonctions `get`, `post`, `put` et `delete`. Ainsi que l'adresse de l'api.

- `responsiveHandler.dart`: comme documenté dans ce fichier, il rassemble les fonctions utiliss pour adapter les widgets aux différentes tailles d'écrans définies dans le projet Figma de SCO2.

## Installation

L'application est d'hors et déjà disponible en live web à l'adresse suivante : [https://app.social-co2.vld-group.com](https://app.social-co2.vld-group.com).

Si vous souhaitez la répliquer sur votre appareil, veuillez suivre les étapes suivantes.

1. Installer Flutter sur votre appareil depuis [la documentation en ligne](https://docs.flutter.dev/get-started/install).

2. Cloner le repository
```bash
$ git clone https://github.com/VLD-dev-team/Social-Co2
```

3. Rendez vous dans le dossier collections du code source de l'application puis créez le fichiers `credentials.dart`
```bash
$ cd Social-Co2/application/social_co2/collections
$ touch credentials.dart
```

4. Rendez-vous sur le site internet de l'api de openroute service à l'adresse suivante : https://openrouteservice.org/dev/#/home. Créez-vous une clé API.

5. Entrez cette clé API en tant que variable dans le fichiers `credentials.dart`.
```bash
$ echo 'String openRouteAPIkey = "yourKEY";' > credentials.dart
```

6. Executez l'application en mode test (assurez-vous d'avoir Chrome installé)
```bash
$ flutter run -d Chrome --web-renderer html
```

Pour le build d'application, merci de vous référez à la documentation de flutter.

## Ressources supplémentaires

- Documentation Flutter : https://docs.flutter.dev/get-started/install
- Documentation Firebase Auth pour Flutter : https://firebase.google.com/docs/auth/flutter/start
- Documentation ORS : https://openrouteservice.org/dev/#/api-docs
- Wiki universitaire SCO2 : https://github.com/VLD-dev-team/Social-Co2/wiki

## Crédits

Membres développeurs de l'application
- Valentin MARY - [Github](https://github.com/Vrock691)
- Jeremy DESBOIS - [Github](https://github.com/Gookd)

Repository public du projet : https://github.com/VLD-dev-team/Social-Co2