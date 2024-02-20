const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/')
    .get(async (req, res) => {
        try {
            const userID = req.headers.id;

            if (typeof userID !== 'string') {
                return res.status(400).send('Invalid user ID');
            }

            // On récupère les données depuis la table Firebase
            const userSnapshot = await admin.firestore().collection('users').doc(userID).get();
            if (!userSnapshot.exists) {
                return res.status(404).send('User not found');
            }
            const userData = userSnapshot.data();

            // On récupère le score depuis la base de données SQL
            const sqlQuery = `SELECT score FROM users WHERE userID = ?`;
            const sqlResult = await executeQuery(sqlQuery, [userID]);

            if (sqlResult.length > 0) {
                // On ajoute le score à la réponse JSON
                userData.score = sqlResult[0].score;
            }

            return res.status(200).json(userData);
        } catch (error) {
            console.error('Error retrieving user data:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

module.exports = router;
