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


function scorePassif(multiplicateur, score) {
  if (multiplicateur > 1) {
      return score + 100 * Math.log(multiplicateur);
  } else if (multiplicateur < 1) {
      return score - 100 * Math.log(Math.abs(multiplicateur));
  }
  return score; // On retourne le score inchangé si le multiplicateur = 1
}

function multiplicateur(recycl, nb_habitants, surface, potager, multiplicateur){
  if (recycl==true){
    multiplicateur+=261*nb_habitants
    if (potager==true){
      multiplicateur+=50*nb_habitants
    } else if(potager == false){
      multiplicateur-=50*nb_habitants
    }else{
      const response = {
        error: true,
        error_message: 'Donnée manquante',
        error_code: 32
      }
      return res.status(400).json(response);
    }
  } else if(recycl== false){
      multiplicateur-=261*nb_habitants
  } else {
    const response = {
      error: true,
      error_message: 'Donnée manquante',
      error_code: 32
    }
    return res.status(400).json(response);
  }
  multiplicateur+=(30-emission_chauffage[chauffage])*surface
  return multiplicateur
}

function nouv_trajet(vehicule,distance){
  ajout_score=(60-emission_vehicule[vehicule])*math.log(distance)*1/10
  return ajout_score
}
    
function nouv_achat(article,etat){
  if (etat== true ){//neuf
    ajout_score=emission_article[article]*-1
  }else if (etat==false){//seconde main
    ajout_score=emission_article[article]
  }else{
    const response = {
      error: true,
      error_message: 'Donnée manquante',
      error_code: 32
    }
    return res.status(400).json(response);
  }
  return ajout_score
}
   
function nouv_repas(aliment){
  return (1-emission_aliment[aliment])*10
}

function renovation(meuble){
  return emission_mobilier[meuble]
}


function boite_mail(mail_test){ //a faire tester par l'utilisateur toutes les semaines
  if (mail_test==true){  //l'utilisateur a vidé sa boite mail
    return 5
  }else if (mail_test==false){ //l'utilisateur n'a pas vidé sa boite mail
    return -5
  }else{
    const response = {
      error: true,
      error_message: 'Donnée manquante',
      error_code: 32
    }
    return res.status(400).json(response);
  }
}      

module.exports() = {
  boite_mail,
  renovation,
  nouv_repas,
  nouv_achat,
  nouv_trajet,
  multiplicateur,
  scorePassif
}