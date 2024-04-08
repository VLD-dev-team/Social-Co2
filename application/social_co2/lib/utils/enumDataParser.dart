import 'package:social_co2/collections/MoreInformationsData.dart';

/* Conversions mode de chauffage */

HeatingModes getHeatingModeFromString(String data) {
  switch (data) {
    case "wood_pellet":
      return HeatingModes.pellet;
    case "electric":
      return HeatingModes.electrique;
    case "wood_stove":
      return HeatingModes.bois;
    case "gas":
      return HeatingModes.gaz;
    case "fuel_oil":
      return HeatingModes.fioul;
    default:
      return HeatingModes.electrique;
  }
}

String getHeatingModeLabelFromEnum(HeatingModes mode) {
  switch (mode) {
    case HeatingModes.pellet:
      return "wood_pellet";
    case HeatingModes.electrique:
      return "electric";
    case HeatingModes.bois:
      return "wood_stove";
    case HeatingModes.gaz:
      return "gas";
    case HeatingModes.fioul:
      return "fuel_oil";
    default:
      return "electric";
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

int getCarSizeLabelFromEnum(CarSizes size) {
  switch (size) {
    case CarSizes.big:
      return 1;
    case CarSizes.mid:
      return 2;
    case CarSizes.small:
      return 3;
    default:
      return 2;
  }
}
