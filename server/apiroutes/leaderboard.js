const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const {verifyAuthToken} = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/world')
    .get(async (req, res) => {
        // Chargement du classement de tous les utilisateurs
        const userID = req.headers.userid;

        // Vérification des types
        if (typeof userID !== 'string') {
            const response = {
                error: true,
                error_message: 'Invalid user ID',
                error_code: 1
            };
            return res.status(400).json(response);
        }

        try {
            // Récupération de tous les utilisateurs ordonnés par score
            const getLeaderboardQuery = `
                SELECT *
                FROM users
                ORDER BY score DESC;
            `;
            const leaderboardResult = await executeQuery(getLeaderboardQuery);

            // Construction de la réponse avec les informations demandées
            const leaderboard = await Promise.all(leaderboardResult.map(async (user) => {
                const userData = await admin.auth().getUser(user.userID);
                let surname = userData.displayName;
                let photoURL = userData.photoURL;
                if (typeof userData.displayName !== "string"){
                    surname = null
                }
                if (typeof userData.photoURL !== "string"){
                    photoURL = null
                }

                return {
                    uid: userData.uid,
                    name: surname,
                    photoURL: photoURL,
                    score: user.score
                };
            }));

            const response = {
                leaderboard : leaderboard,
                status : 200,
                message: "leaderboard load succesfull"
            }

            return res.status(200).json(response);
        } catch (error) {
            console.error('Error fetching leaderboard:', error);
            const response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            };
            return res.status(500).json(response);
        }
    });

router.route('/friends')
    .get(async (req, res) => {
        // Classement des amis
        const userID = req.headers.userid;

        // Vérification des types
        if (typeof userID !== 'string') {
            const response = {
                error: true,
                error_message: 'Invalid user ID',
                error_code: 1
            };
            return res.status(400).json(response);
        }

        try {
            // Récupérer les amis de l'utilisateur
            const getFriendsQuery = `
                SELECT userID1, userID2
                FROM friends
                WHERE (userID1 = ? OR userID2 = ?) AND friendshipStatus = '22';
            `;
            const friendsResult = await executeQuery(getFriendsQuery, [userID, userID]);

            if (friendsResult.length === 0) {
                const response = {
                    error: true,
                    error_message: 'User has no friends',
                    error_code: 3
                };
                return res.status(400).json(response);
            }

            // Extraire les IDs des amis
            const friendIDs = friendsResult.map(friendship => {
                return friendship.userID1 === userID ? friendship.userID2 : friendship.userID1;
            });

            friendIDs.push(userID);

            // Récupérer les détails des amis ordonnés par score
            const getLeaderboardQuery = `
                SELECT *
                FROM users
                WHERE userID IN (?)
                ORDER BY score DESC;
            `;
            const leaderboardResult = await executeQuery(getLeaderboardQuery, [friendIDs]);

            // Construction de la réponse avec les informations demandées
            const leaderboard = await Promise.all(leaderboardResult.map(async (user) => {
            const userData = await admin.auth().getUser(user.userID);
            let surname = userData.displayName;
                let photoURL = userData.photoURL;
                if (typeof userData.displayName !== "string"){
                    surname = null
                }
                if (typeof userData.photoURL !== "string"){
                    photoURL = null
                }
                return {
                    uid: userData.uid,
                    name: surname,
                    photoURL: photoURL,
                    score: user.score
                };
            }));

            const response = {
                leaderboard : leaderboard,
                status : 200,
                message: "leaderboard load succesfull"
            }

            return res.status(200).json(response);
        } catch (error) {
            console.error('Error fetching friends leaderboard:', error);
            const response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            };
            return res.status(500).json(response);
        }
    });


module.exports = router;
