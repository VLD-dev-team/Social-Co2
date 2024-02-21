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

            // Récupérétation des informations d'authentification de l'utilisateur
            const authUser = await admin.auth().getUser(userID);

            // On récupère le score depuis la base de données SQL
            const sqlQuery = `SELECT score FROM users WHERE userID = ?`;
            const sqlResult = await executeQuery(sqlQuery, [userID]);

            if (sqlResult.length > 0) {
                // Création d'un objet avec les données d'authentification et le score
                const userData = {
                    authInfo: {
                        userId : userID,
                        uid: authUser.uid,
                        email: authUser.email,
                        dateCreation: authUser.metadata.creationTime,
                        derniereConnexion: authUser.metadata.lastSignInTime
                    },
                    score: sqlResult[0].score,
                };

                return res.status(200).json(userData);
            } else {
                return res.status(404).send('User not found in SQL database');
            }
        } catch (error) {
            console.error('Error retrieving user data:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

module.exports = router;