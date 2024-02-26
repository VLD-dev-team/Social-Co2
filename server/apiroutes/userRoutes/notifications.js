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

            // Requête pour obtenir les 10 dernières notifications de l'utilisateur
            const getNotificationsQuery = `
                SELECT * FROM notifications
                WHERE userID = ?
                ORDER BY notificationID DESC
                LIMIT 10`;

            const notifications = await executeQuery(getNotificationsQuery, [userID]);

            return res.status(200).json(notifications);
        } catch (error) {
            console.error('Error retrieving notifications:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

module.exports = router;
