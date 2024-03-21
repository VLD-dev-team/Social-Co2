const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
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

        // On y récupère et dans l'ordre
        const getLeaderboard = `
                SELECT *
                FROM users
                ORDER BY score DESC ;`;
        const leaderboardResult = executeQuery(getLeaderboard);

        // Gestion d'erreur
        if (leaderboardResult.length > 0) {
            let response = {};
            for (let each of leaderboardResult) {
                const authUser = await admin.auth().getUser(each.userID);
                response[authUser.displayName] = leaderboardResult[each];
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
   }
);

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

        const getFriendsQuery = `
                SELECT userID1, userID2
                FROM friends
                WHERE (userID1 = ? OR userID2 = ?) AND friendshipStatus = '22' ;
            `;
        const friendsResult = executeQuery(getFriendsQuery, [userID, userID]);

        // Vérifiez si l'utilisateur a des amis
        if (friendsResult.length === 0) {
            const response = {
                error: true,
                error_message: 'User has no friends',
                error_code: 3
            };
            return res.status(400).json(response);
        }

        // Extraire les IDs des amis (-:
        const friendIDs = friendsResult.map(friendship => {
            return friendship.userID1 === userID ? friendship.userID2 : friendship.userID1;
        });

        friendIDs.push(userID);

        // On affiche et dans l'ordre
        const getLeaderboard = `
                SELECT *
                FROM users
                WHERE userID IN (?)
                ORDER BY score DESC ;`;
        const leaderboardResult = executeQuery(getLeaderboard, [friendIDs]);

        // Gestion des erreurs
        if (leaderboardResult.length > 0) {
            let response = {};
            for (let each of leaderboardResult) {
                const authUser = await admin.auth().getUser(each.userID);
                response[authUser.displayName] = leaderboardResult[each];
                response[each.userID] = each;
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
    }
);

module.exports = router;
