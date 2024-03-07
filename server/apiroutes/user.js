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
            const userID = req.headers.userid;

            if (typeof userID !== 'string') {
                const response = {
                        error : true,
                        error_message : 'Invalid user ID',
                        error_code : 1
                }
                return res.status(400).json(response);
            }

            // Récupérétation des informations d'authentification de l'utilisateur
            const authUser = await admin.auth().getUser(userID);

            // On récupère le score depuis la base de données SQL
            const sqlQuery = `SELECT score FROM users WHERE userID = ? ;`;
            const sqlResult = await executeQuery(sqlQuery, [userID]);

            if (sqlResult.length > 0) {
                // Création d'un objet avec les données d'authentification et le score
                const response = {
                        authInfo: {
                            userId : userID,
                            uid: authUser.uid,
                            email: authUser.email,
                            dateCreation: authUser.metadata.creationTime,
                            derniereConnexion: authUser.metadata.lastSignInTime
                        },
                        score: sqlResult[0].score,
                    }
                return res.status(200).json(response);

            } else {
                const response = {
                        error : true,
                        error_message : 'User not found in SQL database',
                        error_code : 3
                }
                return res.status(400).json(response);
            }
        } catch (error) {
            console.error('Error retrieving user data:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

module.exports = router;