const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));
    // Vérification de la connexion

router.route('/')
    .get(async (req, res) => {
        // Mise en place d'un try catch dans le but de préventir d'éventuelles erreurs si jamais on ne trouve aucune activités
        try {
            const userID = req.headers.userid;
            const startIndex = parseInt(req.query.index) || 0; // Index de départ, par défaut 0

            // Requête pour obtenir les 20 dernières activités de l'utilisateur à partir de l'index spécifié
            const getActivitiesQuery = `
                SELECT * FROM activities
                WHERE userID = ?
                ORDER BY activityTimestamp DESC
                LIMIT 20
                OFFSET ? ;`;
                // OFFSET pour spécifier l'index auquel on part, trop bien !

            const activities = await executeQuery(getActivitiesQuery, [userID, startIndex]);

            const response = {
                activities : activities,
                status : 200,
            }
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error retrieving activities:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });


router.route('/favorite')
    .get(async (req, res) => {
        // Mise en place d'un try catch dans le but de préventir d'éventuelles erreurs
        try {
            const userID = req.headers.userid;
            const startIndex = parseInt(req.query.index) || 0; // Index de départ, par défaut 0

            // Requête pour obtenir les 20 dernières activités de l'utilisateur à partir de l'index spécifié
            const getActivitiesFavQuery = `
                SELECT * FROM reccurentActivities
                WHERE userID = ?
                ORDER BY activityTimestamp DESC
                LIMIT 20
                OFFSET ? ;`;
                // OFFSET pour spécifier l'index auquel on part, trop bien !

            const activitiesfav = await executeQuery(getActivitiesFavQuery, [userID, startIndex]);

            const response = {
                activitiesfav : activitiesfav,
                status : 200,
            }
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error retrieving activities:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });





module.exports = router;
