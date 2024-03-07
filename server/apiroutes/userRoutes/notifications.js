const express = require('express');
const router = express.Router();
const { executeQuery } = require('../../utils/database.js');
const verifyAuthToken = require('../../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;

            // Requête pour obtenir les 10 dernières notifications de l'utilisateur
            const getNotificationsQuery = `
                SELECT * FROM notifications
                WHERE userID = ?
                ORDER BY notificationID DESC
                LIMIT 10 ;`;

            const notifications = await executeQuery(getNotificationsQuery, [userID]);

            const response = {
                notifications : notifications,
                status : 200,
            }
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error retrieving notifications:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

module.exports = router;
