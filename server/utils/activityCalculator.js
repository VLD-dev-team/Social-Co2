math.import(functions)

activite = {
    emission_chauffage : {
      "pellet":6, 
      "electrique":8,
      "poele a bois":9,
      "gaz":39,
      "fioul":57
      },
    emission_vehicule : {
      "voiture_electrique":20,
      "moto":165,
      "bus":110,
      "avion":250,
      "ter":22,
      "rer":10,
      "tgv":2.3,
      "a_pied":0,
      "velo":0,
      "velo ou trotinnette electrique":2,
      "metro":4.2,
      "tram":4.3,
      "covoiturage":55,
    },
    emission_article : {
      "vetement":10,
      "electromenager":300,
      "ordinateur":150,
      "telephone":40
    },
    emission_aliment : {
      "vegetarien":0.5,
      "poisson gras":1,
      "poisson blanc":2,
      "poulet":1.6,
      "boeuf":7,
      "autre viande":2
      },
    emission_mobilier : {
      "chaise":19,
      "table":80,
      "canape":180,
      "lit":450,
      "armoire":900
    }
  }

const ActivityCalculator = (req,res)=>{
    const ActivityType = req.body.activityType;
    const element = req.body.activityElement;

    if (ActivityType == "emission_chauffage"){
        const recycl = req.body.recycl // bool
        const nb_habitants = req.body.nb_habitants // int
        const surface = req.body.surface // int
        const patager = req.body.potager // bool
        let multiplicateur=1
        if (recycl==true){
            multiplicateur+=261*nb_habitants
        } else if(recycl== false){
            multiplicateur-=261*nb_habitants
        }
    if potager==1:
        multiplicateur+=50*nb_habitants
    elif potager==0:
        multiplicateur-=50*nb_habitants
    multiplicateur+=(30-emission_chauffage[chauffage])*surface
    return multiplicateur
    }
    
}