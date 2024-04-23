import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Rajout du assets en mode deploiement pour les images
String releasePath = kDebugMode ? '' : 'assets/';

enum ResponsiveFormats {
  large,
  mid,
  small,
  mobile
} // Formats disponibles à partir des templates figmas

ResponsiveFormats whichResponsiveFormat(BuildContext context) {
  /* 
    Cette fonction peut être appelé à tout moment et sert à identifier le format
    de l'écran par rapport aux templates figma.
    Chaque dimensions est correspond à une template bien précise.
    La chaine retourné doit permettre d'adapter les widgets et les écrans en
    fonction du format de l'écran.

    CETTE FONCTION N'EST PAS UTILISÉ POUR DIFFÉRENCIER L'APPLICATION MOBILE DU
    SITE INTERNET. LE FICHIER MAIN CONTIENT UNE LOGIQUE PARTICULIÈRE POUR CELA.
    ELLE N'EST APPLICABLE QU'AUX WIDGETS ET À CERTAINS SOUS ÉCRANS.
  */

  MediaQueryData media =
      MediaQuery.of(context); // Obtentions des données de l'affichage

  if (media.size.width >= 1400) {
    // Utilisation sur un écran large -> Medium et max sur Figma
    return ResponsiveFormats.large;
  } else if (media.size.width >= 1200) {
    // Utilisation sur un écran moyen -> Small sur Figma
    return ResponsiveFormats.mid;
  } else if (media.size.width >= 600) {
    // Utilisation web sur un écran très peu large -> XSmall sur Figma
    return ResponsiveFormats.small;
  } else {
    // Utilisation mobile
    return ResponsiveFormats.mobile;
  }
}

int getDrawerWidth(BuildContext context) {
  /* Cette fonction sert à obtenir la largeur du drawer sur web */

  if (kIsWeb) {
    MediaQueryData media =
        MediaQuery.of(context); // Obtentions des données de l'affichage

    if (media.size.width >= 1400) {
      // Utilisation sur un écran large -> Medium et max sur Figma
      return 300;
    } else if (media.size.width >= 1200) {
      // Utilisation sur un écran moyen -> Small sur Figma
      return 300;
    } else if (media.size.width >= 600) {
      // Utilisation web sur un écran très peu large -> XSmall sur Figma
      return 60;
    } else {
      // Utilisation mobile
      return 60;
    }
  } else {
    return 0; // Pas de drawer sur mobile
  }
}
