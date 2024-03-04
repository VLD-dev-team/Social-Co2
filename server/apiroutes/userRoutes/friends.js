const express = require('express');
const router = express.Router();
const { executeQuery } = require('../../utils/database.js');
const verifyAuthToken = require('../../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/')
    .get(async (req, res) => {
        try {
            const userID = req.headers.id;

            // Requête pour obtenir les amis et leurs statuts
            const getFriendsQuery = `
                SELECT 
                    f.friendshipID,
                    f.userID1 AS friendID,
                    u.userName AS friendName,
                    f.friendshipStatus
                FROM friends f
                JOIN users u ON (f.userID1 = u.userID OR f.userID2 = u.userID) AND u.userID != ?
                WHERE f.userID1 = ? OR f.userID2 = ?`;

                // Test d'un nouveau type de requête :)

            const friends = await executeQuery(getFriendsQuery, [userID, userID, userID]);

            return res.status(200).json(friends);
        } catch (error) {
            console.error('Error retrieving friends:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

router.route('/search')
    .get(async (req, res) => {
        try {
            const userID = req.headers.id;
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
                WHERE f.friendshipID = ? `;

            const friend = await executeQuery(searchFriendQuery, [userID, friendshipID]);

            if (friend.length === 0) {
                return res.status(404).json({ message: 'Friend not found' });
            }

            return res.status(200).json(friend[0]);
        } catch (error) {
            console.error('Error searching friend:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

router.route('/status')
    .post(async (req, res) => {
        try {
            const userID = req.headers.id;
            const friendID = req.body.friendID;
            const friendshipStatus = req.body.friendshipStatus;

            // Vérifie si l'amitié existe déjà
            const checkFriendshipQuery = `
                SELECT friendshipID FROM friends
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
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

                return res.status(200).json({ message: 'Friendship status updated successfully' });
            } else {
                // Ajouter une nouvelle amitié
                const addFriendshipQuery = `
                    INSERT INTO friends (userID1, userID2, friendshipStatus)
                    VALUES (?, ?, ?)
                `;
                await executeQuery(addFriendshipQuery, [userID, friendID, friendshipStatus]);

                return res.status(201).json({ message: 'Friend added successfully' });
            }
        } catch (error) {
            console.error('Error updating friendship status:', error);
            return res.status(500).send('Internal Server Error');
        }
    })
    .delete(async (req, res) => {
        try {
            const userID = req.headers.id;
            const friendID = req.body.friendID;

            // Supprimer l'amitié
            const deleteFriendshipQuery = `
                DELETE FROM friends
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
            `;
            const deleteResult = await executeQuery(deleteFriendshipQuery, [userID, friendID, friendID, userID]);

            if (deleteResult.affectedRows > 0) {
                return res.status(200).json({ message: 'Friendship deleted successfully' });
            } else {
                return res.status(404).json({ message: 'Friendship not found' });
            }
        } catch (error) {
            console.error('Error deleting friendship:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

module.exports = router;
