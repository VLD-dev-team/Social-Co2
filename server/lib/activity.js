const activityCalculator = require('../utils/activityCalculator.js')

class Activity {
    constructor(userID, activityType, activityName, activityTimestamp) {
        this.userID = userID,
        this.activityType = activityType,
        this.activityName = activityName,
        this.activityTimestamp = activityTimestamp
        this.activityCO2Impact = 0
    }

    async CalculCO2Impact() {
        let activityCO2Impact = new String;
        if (this.activityType == "trajet"){
            const vehicule = req.body.vehicule
            const distance = req.body.distance
            activityCO2Impact = activityCalculator.nouv_trajet(vehicule,distance)
        } else if (this.activityType == "achat"){
            const article = req.body.article
            const etat = req.body.etat
            activityCO2Impact = activityCalculator.nouv_achat(article,etat)
        } else if (this.activityType == "repas"){
            const aliment = req.body.aliment
            activityCO2Impact = activityCalculator.nouv_repas(aliment)
        } else if (this.activityType == "renovation"){
            const meuble = req.body.meuble
            activityCO2Impact = activityCalculator.renovation(meuble)
        } else if (this.activityType == "mail"){
            const mail_test = req.body.mail
            activityCO2Impact = activityCalculator.boite_mail(mail_test)
        }else{
            const response = {
                error : true,
                error_message : 'Donnée manquante',
                error_code : 31
            }
            return res.status(400).json(response);
        }
        return activityCO2Impact

        
    }
}

module.exports = Activity;