const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');
const activityCalculator = require('../utils/activityCalculator.js')

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
                const sqlQuery = `INSERT INTO users (userID, score) VALUES ( ? , ? ) ;`;
                const sqlResult = await executeQuery(sqlQuery, [userID, 5000]);

                // Création d'un objet avec les données d'authentification et le score
                const response = {
                    userId : userID,
                    score: 5000,
                    message : 'User is defined',
                }
                return res.status(200).json(response);
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
    })
    .put(async (req, res) => {
        try{
            const userID = req.headers.userid;

            if (typeof userID !== 'string') {
                const response = {
                        error : true,
                        error_message : 'Invalid user ID',
                        error_code : 1
                }
                return res.status(400).json(response);
            }

            const recycl = req.body.recycl
            const nb_habitants = req.body.nb_habitants
            const surface = req.body.surface
            const potager = req.body.potager
            const multiplicateur = req.body.multiplicateur

            // Récupérétation des informations d'authentification de l'utilisateur
            const authUser = await admin.auth().getUser(userID);

            // On récupère le score depuis la base de données SQL
            const sqlQuery = `SELECT score FROM users WHERE userID = ? ;`;
            const sqlResult = await executeQuery(sqlQuery, [userID]);

            if (sqlResult.length > 0) {
                // Création d'un objet avec les données d'authentification et le score
                    const newscore = activityCalculator.scorePassif(activityCalculator.multiplicateur(recycl, nb_habitants, surface, potager, multiplicateur),sqlResult[0].score)
                    const updateQuery = `UPDATE TABLE user SET score = ? WHERE userID = ? ;`;
                    const updateResult = await executeQuery(updateQuery, [newscore , userID]);

                    const response = {
                        userId : userID,
                        score: newscore,
                        message : 'Score has been update',
                    }
                    return res.status(200).json(response);
            } else {
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
    })
    .delete(async (req, res) => {
        try{
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
            const sqlQuery = `DELETE FROM user WHERE userID = ?;`;
            const sqlResult = await executeQuery(sqlQuery, [userID]);
            const sql1Query = `DELETE FROM activities WHERE userID = ?;`;
            const sql1Result = await executeQuery(sql1Query, [userID]);
            const sql2Query = `DELETE FROM recurrentActivities WHERE userID = ?;`;
            const sql2Result = await executeQuery(sql2Query, [userID]);
            const sql3Query = `DELETE FROM notifications WHERE userID = ?;`;
            const sql3Result = await executeQuery(sql3Query, [userID]);
            const sql4Query = `DELETE FROM posts WHERE userID = ?;`;
            const sql4Result = await executeQuery(sql4Query, [userID]);
            const sql5Query = `DELETE FROM likes WHERE userID = ?;`;
            const sql5Result = await executeQuery(sql5Query, [userID]);
            const sql6Query = `DELETE FROM comments WHERE userID = ?;`;
            const sql6Result = await executeQuery(sql6Query, [userID]);

            const response = {
                userId : userID,
                message : 'User has been delete',
            }
            return res.status(200).json(response);
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