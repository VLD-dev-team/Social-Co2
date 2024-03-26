const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');
const activityCalculator = require('../utils/activityCalculator.js')

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));
    // Vérification de la connection

router.route('/')
    .get(async (req, res) => {
        const userid = req.headers.userid;
        const activityid = req.headers.activityid;


        // Vérification des types
        if (typeof userid !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }
        if (isNaN(activityid)) {
            const response = {
                    error : true,
                    error_message : 'Invalid activity ID',
                    error_code : 12
            }
            return res.status(400).json(response);
        }

        // On récupère toutes les infos de l'activité
        const sqlQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const sqlResult = await executeQuery(sqlQuery, [userid, activityid]);


        // On retourne au format JSON
        if (sqlResult.length > 0){
            const response = {
                activityData : {
                    activityID : sqlResult[0].activityID,
                    userID : sqlResult[0].userID,
                    activityType : sqlResult[0].activityType,
                    activityCO2Impact : sqlResult[0].activityCO2Impact,
                    activityName : sqlResult[0].activityName,
                    activityTimestamp : sqlResult[0].activityTimestamp
                },
                status : 200,
                type : 'response'
            }
            return req.status(200).json(response)

        // Si on ne trouve aucune activité correspondante, on retourne une erreur
        }else {
            const response = {
                    error : true,
                    error_message : 'Activity or User not found in SQL database',
                    error_code : 13
            }
            return res.status(404).json(response);
        }
    })
    .post(async (req, res) => {
        // Ajout d'une activité
        // On récupère les données nécessaires à la création d'une activité

        const userID = req.headers.userid;
        const activityType = req.body.activityType; // Voir juste en dessous
        const activityName = req.body.activityName;
        const activityTimestamp = req.body.activityTimestamp;
        
        // On initialise une variable à 0
        let activityCO2Impact = 0;
        // On va calculer l'impact au score en fonction du type d'activité choisi
        if (activityType == "trajet"){
            let vehicule = req.body.vehicule
            if (vehicule == 'voiture'){
                const sqlQuery = 'SELECT voiture, hybride FROM users WHERE userID = ? '
                const sqlResult = await executeQuery(sqlQuery, [userID])
                if (sqlQuery.hybride){
                    if (sqlQuery.voiture == 1){
                        vehicule = 'Grosse voiture hybride'
                    } else if (sqlQuery.voiture == 2){
                        vehicule = 'Moyenne voiture hybride'
                    } else {
                        vehicule = 'Petite voiture hybride'
                    }
                } else {
                    if (sqlQuery.voiture == 1){
                        vehicule = 'Grosse voiture'
                    } else if (sqlQuery.voiture == 2){
                        vehicule = 'Moyenne voiture'
                    } else {
                        vehicule = 'Petite voiture'
                    }
                }
            }
            const distance = req.body.distance
            activityCO2Impact = activityCalculator.nouv_trajet(vehicule,distance)
        } else if (activityType == "achat"){
            const article = req.body.article
            const etat = req.body.etat
            activityCO2Impact = activityCalculator.nouv_achat(article,etat)
        } else if (activityType == "repas"){
            const aliment = req.body.aliment
            activityCO2Impact = activityCalculator.nouv_repas(aliment)
        } else if (activityType == "renovation"){
            const meuble = req.body.meuble
            activityCO2Impact = activityCalculator.renovation(meuble)
        } else if (activityType == "mail"){
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

        // Une fois arrivé ici, on connaît normalement activityCO2Impact, on va maintenant appliqué la fonction score_passif()
        // Pour ce faire on va avoir besoin des divers informations de l'utilisateur
        // Mais avant ça vérifions toutes le données pour préventir des injections SQL

        if (typeof userID !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }
        if (typeof activityType !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid activityType',
                    error_code : 14
            }
            return res.status(400).json(response);
        }
        if (isNaN(activity.activityCO2Impact)) {
            const response = {
                    error : true,
                    error_message : 'Invalid activityCO2Impact',
                    error_code : 15
            }
            return res.status(400).json(response);
        }
        if (isNaN(activityPollutionImpact)) {
            const response = {
                    error : true,
                    error_message : 'Invalid activityPollutionImpact',
                    error_code : 16
            }
            return res.status(400).json(response);
        }
        if (typeof activityName !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid activityName',
                    error_code : 17
            }
            return res.status(400).json(response);
        }

        // Toutes les données ont été vérifiées, passons au calcul

        const selectQuery = `SELECT * FROM users WHERE userID = ?;`;
        const selectResult = await executeQuery(selectQuery, [userID]);

        if (selectResult.length === 0 ) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        } else {

            // On met à jour le score
            let score = selectResult.score + activityCO2Impact
            // Puis on applique le score passif
            score = activityCalculator.scorePassif(activityCalculator.multiplicateur(selectResult.recycl, selectResult.nb_habitants, selectResult.surface, selectResult.potager, selectResult.multiplicateur, selectResult.chauffage), score)

            // On peut maintenant insérer l'activité dans la table activities
            const insertQuery = `
            INSERT INTO activities (userID, activityType, activityCO2Impact, activityName, activityTimestamp)
            VALUES (?, ?, ?, ?, ?) ;`;
            const insertResult = await executeQuery(insertQuery, [userID, activityType, activityCO2Impact, activityName, activityTimestamp]);

            if (insertResult.affectedRows > 0) {
                
            // On va mettre à jour le score de l'utilisateur avec celui qu'on a calculé
            const updateQuery = `UPDATE TABLE users SET score = ? WHERE userID = ? ;`;
            const updateResult = await executeQuery(updateQuery, [parseInt(score) , userID]);
                
            // On renvoie un JSON
            const activityID = insertResult.insertId;
                const response = {
                        activityID : activityID,
                        userID : userID,
                        activityType : activityType,
                        activityCO2Impact : activityCO2Impact,
                        activityName : activityName,
                        activityTimestamp : activityTimestamp
                }

            return res.status(200).json(response);
            } else {
                const response = {
                        error : true,
                        error_message : 'Failed to insert activity',
                        error_code : 18
                }
                return res.status(500).json(response);
            }
        }
    })
    .put(async (req, res) => {
        // Pour mettre à jour une activité
        // On récupère toutes les données
        const userID = req.headers.userid;
        const activityId = req.body.activityid;
        const activityType = req.body.activityType;
        const activityCO2Impact = req.body.activityCO2Impact;
        const activityName = req.body.activityName;
        const activityTimestamp = req.body.activityTimestamp;

        // Vérifications du typage

        if (typeof userID !== 'string' || isNaN(activityId)) {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID or activity ID',
                    error_code : 19
            }
            return res.status(400).json(response);
        }

        // On vérifie si l'activité est déjà existante
        const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const permissionResult = await executeQuery(permissionQuery, [userID, activityId]);

        if (permissionResult.length === 0) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        }

        // On met à jour la table activities avec les nouvelles infos

        const updateQuery = `
            UPDATE activities
            SET activityType = ?, activityCO2Impact = ?,
                activityName = ?, activityTimestamp = ?
            WHERE userID = ? AND activityID = ? ;
        `;
        const updateResult = await executeQuery(updateQuery, [activityType, activityCO2Impact, activityName, activityTimestamp, userID, activityId]);

        if (updateResult.affectedRows > 0) {
            const response = {
                    activityID: activityId,
                    userID : userID,
                    activityType : activityType,
                    activityCO2Impact : activityCO2Impact,
                    activityName : activityName,
                    activityTimestamp : activityTimestamp
            }
            return res.status(200).json(response);
        } else {
            const response = {
                    error : true,
                    error_message : 'Failed to update activity',
                    error_code : 21
            }
            return res.status(500).json(response);
        }
    })
    .delete(async (req, res) => {
        // On récupère les infos nécessaire à la suppression
        const userID = req.headers.userid;
        const activityId = req.params.activityId;

        // Vérification du typage

        if (typeof userID !== 'string' || isNaN(activityId)) {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID or activity ID',
                    error_code : 19
            }
            return res.status(400).json(response);
        }

        // Vérification de la permission

        const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const permissionResult = await executeQuery(permissionQuery, [userID, activityId]);

        if (permissionResult.length === 0) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        }

        // On supprime l'activité
        const deleteQuery = `DELETE FROM activities WHERE userID = ? AND activityID = ? ;`;
        const deleteResult = await executeQuery(deleteQuery, [userID, activityId]);

        if (deleteResult.affectedRows > 0) {
            const response = {
                message : 'Activity deleted successfully',
                status : 200,
            }
            return res.status(200).json(response);
        } else {
            const response = {
                    error : true,
                    error_message : 'Failed to delete activity',
                    error_code : 21
            }
            return res.status(500).json(response);
        }
    });

router.route('/favorite')
    .post(async (req,res) => {
        const userID = req.headers.userid
        const activityID = req.body.activityid

        // Vérification du typage

        if (typeof userID !== 'string' || isNaN(activityId)) {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID or activity ID',
                    error_code : 19
            }
            return res.status(400).json(response);
        }

        // Vérification de la permission

        const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const permissionResult = await executeQuery(permissionQuery, [userID, activityID]);

        if (permissionResult.length === 0) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        } else {
            const insertQuery = `
            INSERT INTO reccurentActivities (activityID, userID, activityType, activityCO2Impact, activityName, activityTimestamp)
            VALUES (?, ?, ?, ?, ?, ?) ;`;
            const insertResult = await executeQuery(insertQuery, [activityID , userID, permissionResult.activityType, permissionResult.activityCO2Impact, permissionResult.activityName, permissionResult.activityTimestamp]);

            if (insertResult.affectedRows > 0) {
                const response = {
                    message : 'Activity add to favorites successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
                }
                return res.status(403).json(response);
            }
        }
    })
    .delete(async (req,res) => {
        const userID = req.headers.userid
        const activityID = req.body.activityid

        // Vérification du typage

        if (typeof userID !== 'string' || isNaN(activityID)) {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID or activity ID',
                    error_code : 19
            }
            return res.status(400).json(response);
        }

        // Vérification de la permission

        const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const permissionResult = await executeQuery(permissionQuery, [userID, activityID]);

        if (permissionResult.length === 0) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        } else {
            const deleteQuery = `DELETE FROM reccurentActivities WHERE activityID = ? AND userID = ? ;`;
            const deleteResult = await executeQuery(deleteQuery, [activityID , userID]);

            if (deleteResult.affectedRows > 0) {
                const response = {
                    message : 'Activity delete from favorites successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                const response = {
                    error : true,
                    error_message : 'User doesnt have this activity in favorite',
                    error_code : 32
                }
                return res.status(400).json(response);
            }
        }
    });

module.exports = router;


    
