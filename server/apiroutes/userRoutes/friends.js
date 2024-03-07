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

            // Requête pour obtenir les amis et leurs statuts
            const getFriendsQuery = `
                SELECT 
                    f.friendshipID,
                    f.userID1 AS friendID,
                    u.userName AS friendName,
                    f.friendshipStatus
                FROM friends f
                JOIN users u ON (f.userID1 = u.userID OR f.userID2 = u.userID) AND u.userID != ?
                WHERE f.userID1 = ? OR f.userID2 = ? ;`;

                // Test d'un nouveau type de requête :)

            const friends = await executeQuery(getFriendsQuery, [userID, userID, userID]);

            const response = {
                friends : friends,
                status : 200,
            }
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error retrieving friends:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

router.route('/search')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const friendshipID = req.query.friendshipId;

            // Requête pour rechercher une personne par son friendshipID
            const searchFriendQuery = `
                SELECT 
                    f.friendshipID,
                    f.userID1 AS friendID,
                    u.userName AS friendName,
                    f.friendshipStatus
                FROM friends f
                JOIN users u ON (f.userID1 = u.userID OR f.userID2 = u.userID) AND u.userID != ?
                WHERE f.friendshipID = ? ;`;

            const friend = await executeQuery(searchFriendQuery, [userID, friendshipID]);

            if (friend.length === 0) {
                const response = {
                        error : true,
                        error_message : 'Friend not found',
                        error_code : 27
                }
                return res.status(404).json(response);
            }
            const response = {
                friend : friend[0],
                status : 200,
            }
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error searching friend:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

router.route('/status')
    .post(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const friendID = req.body.friendID;
            const friendshipStatus = req.body.friendshipStatus;

            // Vérifie si l'amitié existe déjà
            const checkFriendshipQuery = `
                SELECT friendshipID FROM friends
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?) ;
            `;
            const existingFriendship = await executeQuery(checkFriendshipQuery, [userID, friendID, friendID, userID]);

            if (existingFriendship.length > 0) {
                // Met à jour le statut de l'amitié existante
                const updateFriendshipQuery = `
                    UPDATE friends
                    SET friendshipStatus = ?
                    WHERE friendshipID = ?
                `;
                await executeQuery(updateFriendshipQuery, [friendshipStatus, existingFriendship[0].friendshipID]);

                const response = {
                    message : 'Friendship status updated successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                // Ajouter une nouvelle amitié
                const addFriendshipQuery = `
                    INSERT INTO friends (userID1, userID2, friendshipStatus)
                    VALUES (?, ?, ?) ;
                `;
                await executeQuery(addFriendshipQuery, [userID, friendID, friendshipStatus]);

                const response = {
                    message : 'Friendship added successfully',
                    status : 201,
                }
                return res.status(201).json(response);
            }
        } catch (error) {
            console.error('Error updating friendship status:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    })
    .delete(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const friendID = req.body.friendID;

            // Supprimer l'amitié
            const deleteFriendshipQuery = `
                DELETE FROM friends
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?) ;
            `;
            const deleteResult = await executeQuery(deleteFriendshipQuery, [userID, friendID, friendID, userID]);

            if (deleteResult.affectedRows > 0) {
                const response = {
                    message : 'Friendship deleted successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                const response = {
                        error : true,
                        error_message : 'Friendship not found',
                        error_code : 28
                }
                return res.status(404).json(response);
            }
        } catch (error) {
            console.error('Error deleting friendship:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

module.exports = router;
