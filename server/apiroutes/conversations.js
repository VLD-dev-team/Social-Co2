const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const notificationHandler = require('../utils/notificationHandler.js'); // Importez le gestionnaire de notifications
const socketManager = require('../utils/socketManager.js'); // Importez le gestionnaire de sockets pour accéder à `io`



router.route('/conversations')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;

            const getConversationsQuery = `
                SELECT * FROM conversations WHERE (userID1 = ? OR userID2 = ?) AND convLastMessage IS NOT NULL ORDER BY convCreatedAt DESC ;`;
            const conversationsResult = await executeQuery(getConversationsQuery, [userID, userID]);

            const response = {
                conversations : conversationsResult,
                status : 200,
            }
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error retrieving conversations:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);        }
    })
    .post(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const friendID = req.body.friendID;

            // Vérifie le statut de l'amitié entre l'utilisateur et son ami
            const checkFriendshipQuery = `
                SELECT friendshipStatus FROM friends
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?) ;
            `;
            const checkFriendshipResult = await executeQuery(checkFriendshipQuery, [userID, friendID, friendID, userID]);
            // Si c'est 22 c'est ok :)
            if (checkFriendshipResult.length === 0 || checkFriendshipResult[0].friendshipStatus !== '22') {
                const response = {
                        error : true,
                        error_message : 'Users are not friends or friendship status is not accepted. Conversation cannot be created.',
                        error_code : 23
                }
                return res.status(400).json(response);
            }

            // Vérifie si une conversation existe déjà entre les deux utilisateurs, sinon on va pas s'embêter
            const checkConversationQuery = `
                SELECT convID FROM conversations
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?) ;
            `;
            const checkConversationResult = await executeQuery(checkConversationQuery, [userID, friendID, friendID, userID]);

            if (checkConversationResult.length > 0) {
                const response = {
                        error : true,
                        error_message : 'Conversation already exists.',
                        error_code : 24
                }
                return res.status(400).json(response);
            }

            // Créer la nouvelle conversation
            const createConversationQuery = `
                INSERT INTO conversations (userID1, userID2, convCreatedAt)
                VALUES (?, ?, CURRENT_TIMESTAMP) ;
            `;
            const createConversationResult = await executeQuery(createConversationQuery, [userID, friendID]);

            if (createConversationResult.affectedRows === 0) {
                const response = {
                        error : true,
                        error_message : 'Failed to create conversation.',
                        error_code : 25
                }
                return res.status(500).json(response);
            }


            const response = {
                message : 'Conversation created successfully.',
                status : 201,
            }
            return res.status(201).json(response);
        } catch (error) {
            console.error('Error creating conversation:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

module.exports = router;
