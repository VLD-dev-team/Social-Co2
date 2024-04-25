[Accueil de la documentation](https://github.com/VLD-dev-team/Social-Co2/blob/main/README.md#social-co2)

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
    * Configuration requises
    * Clés API
    * Procédure de mise en place
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

    * Fichiers styles (``styles``)
    * Fichiers collections (`collections`)
    * Classes de données (`classes`)
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

