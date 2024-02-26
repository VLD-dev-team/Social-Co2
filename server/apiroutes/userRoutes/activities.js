const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/')
    .get(async (req, res) => {
        try {
            const userID = req.headers.id;
            const startIndex = parseInt(req.query.index) || 0; // Index de départ, par défaut 0

            // Requête pour obtenir les 20 dernières activités de l'utilisateur à partir de l'index spécifié
            const getActivitiesQuery = `
                SELECT * FROM activities
                WHERE userID = ?
                ORDER BY activityTimestamp DESC
                LIMIT 20
                OFFSET ?`;
                // OFFSET pour spécifier l'index auquel on part, trop bien !

            const activities = await executeQuery(getActivitiesQuery, [userID, startIndex]);

            return res.status(200).json(activities);
        } catch (error) {
            console.error('Error retrieving activities:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

module.exports = router;
