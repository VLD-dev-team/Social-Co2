import 'package:social_co2/collections/MoreInformationsData.dart';

/* Conversions mode de chauffage */

HeatingModes getHeatingModeFromString(String data) {
  switch (data) {
    case "pellet":
      return HeatingModes.pellet;
    case "electrique":
      return HeatingModes.electrique;
    case "poele a bois":
      return HeatingModes.bois;
    case "gaz":
      return HeatingModes.gaz;
    case "fioul":
      return HeatingModes.fioul;
    default:
      return HeatingModes.electrique;
  }
}

String getHeatingModeLabelFromEnum(HeatingModes mode) {
  switch (mode) {
    case HeatingModes.pellet:
      return "pellet";
    case HeatingModes.electrique:
      return "electrique";
    case HeatingModes.bois:
      return "poele a bois";
    case HeatingModes.gaz:
      return "gaz";
    case HeatingModes.fioul:
      return "fioul";
    default:
      return "electrique";
  }
}

/* Conversion taille de la voiture */

CarSizes getCarSizeFromInt(int data) {
  switch (data) {
    case 1:
      return CarSizes.small;
    case 2:
      return CarSizes.mid;
    case 3:
      return CarSizes.big;
    default:
      return CarSizes.mid;
  }
}

String getCarSizeLabelFromEnum(CarSizes size) {
  switch (size) {
    case CarSizes.big:
      return "big";
    case CarSizes.mid:
      return "mid";
    case CarSizes.small:
      return "small";
    default:
      return "mid";
  }
}
