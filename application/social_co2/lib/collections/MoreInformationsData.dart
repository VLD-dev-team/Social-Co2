enum HeatingModes { gaz, pellet, bois, electrique, fioul }

const Map<HeatingModes, String> heatingModesNames = {
  HeatingModes.bois: "Poêle à bois",
  HeatingModes.electrique: "Éléctrique",
  HeatingModes.fioul: "Fioul",
  HeatingModes.gaz: "Gaz",
  HeatingModes.pellet: "Pellet"
};

enum CarSizes { small, mid, big }

const Map<CarSizes, String> carSizesNames = {
  CarSizes.small: "Petite voiture",
  CarSizes.mid: "Voiture moyenne",
  CarSizes.big: "Véhicule imposant"
};
