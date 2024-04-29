const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');

// router.route('/*')
//     .all((req, res, next) => verifyAuthToken(req, res, next));
//     // Vérification de la connexion

router.route('/')
    .get(async (req, res) => {
        const userID = req.headers.userid;
        const startIndex = parseInt(req.query.index) || 0; // Index de départ, par défaut 0

        // Requête pour obtenir les 20 dernières activités de l'utilisateur à partir de l'index spécifié
        const getActivitiesQuery = `
            SELECT *, DATE_ADD(activityTimestamp, INTERVAL 2 HOUR) AS adjustedTimestamp FROM activities
            WHERE userID = ?
            ORDER BY activityTimestamp DESC
            LIMIT 20
            OFFSET ? ;`;
            // OFFSET pour spécifier l'index auquel on part, trop bien !

        const activities = await executeQuery(getActivitiesQuery, [userID, startIndex]);
        console.log(activities)
        if (activities.length >0){
            const response = {
                activities : activities,
                status : 200,
            }
            return res.status(200).json(response);
        } else {
            const response = {
                error : true,
                error_message : 'Invalid userID',
                error_code : 1
            }
            return res.status(400).json(response);
        }
    });


router.route('/favorite')
    .get(async (req, res) => {
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

        if (activitiesfav.length > 0){
            const response = {
                activitiesfav : activitiesfav,
                status : 200,
            }
            return res.status(200).json(response);
        } else {
            const response = {
                error : true,
                error_message : 'Invalid userID',
                error_code : 1
            }
            return res.status(400).json(response);
        }
    });





module.exports = router;
