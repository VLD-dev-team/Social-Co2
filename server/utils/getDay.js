// Fonction pour obtenir le jour à partir d'un timestamp ISO
function obtenirNomJourEtDate(timestampISO) {
    // Créer un objet Date à partir du timestamp ISO
    var date = new Date(timestampISO);
    
    // Récupérer le nom du jour
    var nomsJours = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
    var nomJour = nomsJours[date.getDay()];
    
    // Récupérer la date
    var jour = date.getDate();
    var mois = date.toLocaleString('default', { month: 'long' });
    
    // Construire la chaîne de caractères avec le nom du jour et la date
    var resultat = nomJour + ' ' + jour + ' ' + mois;
    
    return resultat;
}

module.exports = obtenirNomJourEtDate;
