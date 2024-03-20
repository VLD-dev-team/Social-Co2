const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');

const activite = {
    "emission_chauffage" : {
      "pellet":6, 
      "electrique":8,
      "poele a bois":9,
      "gaz":39,
      "fioul":57
      },
    "emission_vehicule" : {
      "Grosse voiture hybride" : 110,
      "Moyenne voiture hybride" : 100,
      "Petite voiture hybride" : 80,
      "Grosse voiture" : 195,
      "Moyenne voiture" : 180,
      "Petite voiture" : 175,
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
    "emission_article" : {
      "vetement":10,
      "electromenager":300,
      "ordinateur":150,
      "telephone":40
    },
    "emission_aliment" : {
      "vegetarien":0.5,
      "poisson gras":1,
      "poisson blanc":2,
      "poulet":1.6,
      "boeuf":7,
      "autre viande":2
      },
    "emission_mobilier" : {
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

function multiplicateur(recycl, nb_habitants, surface, potager, multiplicateur, chauffage){
  if (recycl==true){
    multiplicateur+=261*nb_habitants
    if (potager==true){
      multiplicateur+=50*nb_habitants
    } else if(potager == false){
      multiplicateur-=50*nb_habitants
    }
  } else if(recycl== false){
      multiplicateur-=261*nb_habitants
  }
  multiplicateur+=(30-activite["emission_chauffage"][chauffage])*surface
  return multiplicateur
}

function nouv_trajet(vehicule,distance){
  ajout_score=(60-activite["emission_vehicule"][vehicule])*Math.log(distance)*1/10
  return ajout_score
}
    
function nouv_achat(article,etat){
  if (etat== true ){//neuf
    ajout_score=activite["emission_article"][article]*-1
  }else if (etat==false){//seconde main
    ajout_score=activite["emission_article"][article]
  }
  return ajout_score
}
   
function nouv_repas(aliment){
  return (1-activte["emission_aliment"][aliment])*10
}

function renovation(meuble){
  return activite["emission_mobilier"][meuble]
}


function boite_mail(mail_test){ //a faire tester par l'utilisateur toutes les semaines
  if (mail_test==true){  //l'utilisateur a vidé sa boite mail
    return 5
  }else if (mail_test==false){ //l'utilisateur n'a pas vidé sa boite mail
    return -5
  }
}      

module.exports = {
  boite_mail,
  renovation,
  nouv_repas,
  nouv_achat,
  nouv_trajet,
  multiplicateur,
  scorePassif
}