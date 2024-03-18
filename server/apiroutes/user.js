const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');
const activityCalculator = require('../utils/activityCalculator.js')
const sendNotificationDaily = require('../utils/emailSender.js')

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/')
    .get(async (req, res) => {
        const userID = req.headers.userid;
        // Vérification du typage

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
        const sqlQuery = `SELECT * FROM users WHERE userID = ? ;`;
        const sqlResult = await executeQuery(sqlQuery, [userID]);

        if (sqlResult.length > 0) {
            // Création d'un objet avec les données d'authentification et le score
            const response = {
                    userId : userID,
                    uid: authUser.uid,
                    email: authUser.email,
                    dateCreation: authUser.metadata.creationTime,
                    derniereConnexion: authUser.metadata.lastSignInTime,
                    score: sqlResult[0].score,
                    recycl : sqlResult[0].recycl,
                    nb_habitants : sqlResult[0].nb_habitants,
                    surface : sqlResult[0].surface,
                    potager : sqlResult[0].potager,
                    multiplicateur : sqlResult[0].multiplicateur,
                    voiture : sqlResult[0].voiture,
                    hybride : sqlResult[0].hybride
                }
            return res.status(200).json(response);
        } else {
            // Il y a du avoir une erreur côté serveur
            const response = {
                error : true,
                error_message : 'Internal Server Error',
                error_code : 2
            }
            return res.status(500).json(response);
        }
    })
    .put(async (req, res) => {
        const userID = req.headers.userid;

        // Vérification du typage
        if (typeof userID !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }

        // On récupère les paramètres directement sur la page pour mettre à jour la BDD

        const recycl = req.body.recycl
        const nb_habitants = req.body.nb_habitants
        const surface = req.body.surface
        const potager = req.body.potager
        const voiture = req.body.voiture
        const hybride = req.body.hybride

        if (typeof recycl !== 'boolean' || typeof nb_habitants !== 'number' || typeof surface !== 'number' || typeof potager !== 'boolean' || typeof voiture !== 'number' || typeof hybride !== 'boolean') {
            const response = {
                error: true,
                error_message: 'Invalid parameters',
                error_code: 2
            };
        return res.status(400).json(response);
        }

        // Récupérétation des informations d'authentification de l'utilisateur
        const authUser = await admin.auth().getUser(userID);

        // On récupère le score depuis la base de données SQL
        const sqlQuery = `SELECT score FROM users WHERE userID = ? ;`;
        const sqlResult = await executeQuery(sqlQuery, [userID]);

        if (sqlResult.length > 0) {
            // Création d'un objet avec les données d'authentification et le score
            const newscore = activityCalculator.scorePassif(activityCalculator.multiplicateur(recycl, nb_habitants, surface, potager, multiplicateur),sqlResult[0].score)
            const updateQuery = `UPDATE users SET score = ? WHERE userID = ? ;`;
            const updateResult = await executeQuery(updateQuery, [parseInt(newscore) , userID]);

            // Requête de mise à jour de la table users
            const updateQuery2 = `
            UPDATE users 
            SET recycl = ?, nb_habitants = ?, surface = ?, potager = ?, multiplicateur = ?, voiture = ?
            WHERE userID = ?;
            `;
            const updateResult2 = await executeQuery(updateQuery2, [recycl, nb_habitants, surface, potager, multiplicateur, voiture, userID]);

            if (updateResult2.affectedRows > 0) {
                // Réponse avec les détails de la mise à jour
                const response = {
                    userId: userID,
                    score : newscore,
                    recycl,
                    nb_habitants,
                    surface,
                    potager,
                    multiplicateur,
                    voiture,
                    hybride,
                    message: 'User data has been updated',
                };
                return res.status(200).json(response);
            } else {
                // Gérer le cas où aucun utilisateur n'est trouvé avec cet ID
                const response = {
                    error: true,
                    error_message: 'User not found',
                    error_code: 3
                };
                return res.status(404).json(response);
            }
        } else {
            const response = {
                error: true,
                error_message: 'Internal Server error',
                error_code: 2
            };
            return res.status(500).json(response);
        }
    })
    .delete(async (req, res) => {
        // On va utiliser le try catch pour éviter de gérer toutes les erreurs possibles des requêtes
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
            const sqlQuery = `DELETE FROM users WHERE userID = ?;`;
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
        } catch(error){
            console.error('Error retrieving notifications:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
       
    })
    .post(async(req,res)=> {
        const userID = req.headers.userid;

        // Vérification du typage
        if (typeof userID !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }

        // On récupère les paramètres directement sur la page pour mettre à jour la BDD

        const recycl = req.body.recycl
        const nb_habitants = req.body.nb_habitants
        const surface = req.body.surface
        const potager = req.body.potager
        const multiplicateur = req.body.multiplicateur
        const voiture = req.body.voiture
        const hybride = req.body.hybride

        if (typeof recycl !== 'boolean' || typeof nb_habitants !== 'number' || typeof surface !== 'number' || typeof potager !== 'boolean' || typeof multiplicateur !== 'number' || typeof voiture !== 'number' || typeof hybride !== 'boolean') {
            const response = {
                error: true,
                error_message: 'Invalid parameters',
                error_code: 33
            };
        return res.status(400).json(response);
        }

        // On calcul le score de base avec les paramètres de l'utilisateurs
        const newscore = activityCalculator.scorePassif(activityCalculator.multiplicateur(recycl, nb_habitants, surface, potager, multiplicateur),5000)
        // Maintenant, q'on a vérifié le typage, on peut creer notre utilisateur avec les différents paramètres associés

        const sqlQuery = `INSERT INTO users (userID, score, recycl, nb_habitants, surface, potager, multiplicateur, voiture, hybride) VALUES ( ? , ? , ? , ? , ? , ? , ?, ?, ?) ;`;
        const sqlResult = await executeQuery(sqlQuery, [userID, parseInt(newscore) , recycl, nb_habitants, surface, potager, multiplicateur, voiture, hybride]);

        if (sqlResult.affectedRows > 0){
            // On active la fonction d'envoie d'email toutes les 24 heures
            sendNotificationDaily(userID)
             // Création d'un objet avec les données d'authentification et le score
            const response = {
                userId : userID,
                score: 5000,
                message : 'User is defined',
            }
            return res.status(200).json(response);
        } else {
            const response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            };
        return res.status(500).json(response);
        }
    });

router.route('/activities')
    .get(async(req,res)=> {
        const userID = req.headers.userid;
        const currentTimestamp = req.body.currentTimestamp;

        if (typeof userID !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }

        const sqlQuery = `SELECT * FROM activities WHERE userID = ? AND activityTimestamp = ? ;`;
        const sqlResult = await executeQuery(sqlQuery, [userID, currentTimestamp]);

        if (sqlResult.length > 0 ){
            currentPhrase = "Vous avez effectué les acitivités suivantes : "
            for (activities in sqlResult){
                currentPhrase = currentPhrase + sqlResult[activities].activityName.toString()
            }
            const response = {
                activities : sqlResult,
                phrase : currentPhrase,
            }
            return res.status(200).json(response)
        } else {
            const response = {
                error : true,
                error_message : 'Invalid activity ID',
                error_code : 12
        }
        return res.status(400).json(response);
        }
    });

router.route('/notifications')
    .get(async (req, res) => {
        const userID = req.headers.userid;

        if (typeof userID !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }

        // Requête pour obtenir les 10 dernières notifications de l'utilisateur
        const getNotificationsQuery = `
            SELECT * FROM notifications
            WHERE userID = ?
            ORDER BY notificationID DESC
            LIMIT 10 ;`;

        const notifications = await executeQuery(getNotificationsQuery, [userID]);

        if (notifications.length > 0){
            const response = {
                notifications : notifications,
                status : 200,
            }
            return res.status(200).json(response);
        } else {
            const response = {
                error : true,
                error_message : 'Internal Server Error',
                error_code : 2
            }
            return res.status(500).json(response);
        }
    });


module.exports = router;