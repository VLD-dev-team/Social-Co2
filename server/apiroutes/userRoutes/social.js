const express = require('express');
const router = express.Router();
const { executeQuery } = require('../../utils/database.js');
const verifyAuthToken = require('../../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/feed')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;

            const getFriendsQuery = `
                SELECT userID1, userID2
                FROM friends
                WHERE (userID1 = ? OR userID2 = ?) AND friendshipStatus = '22'
            `;
            const friendsResult = await executeQuery(getFriendsQuery, [userID, userID]);

            // Extraire les IDs des amis (-:
            const friendIDs = friendsResult.map(friendship => {
                return friendship.userID1 === userID ? friendship.userID2 : friendship.userID1;
            });

            friendIDs.push(userID);

            const getFeedQuery = `
                SELECT *
                FROM posts
                WHERE userID IN (?)
                ORDER BY postCreatedAt DESC`;
            const feedResult = await executeQuery(getFeedQuery, [friendIDs]);


            const response = feedResult;
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error retrieving feed:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

router.route('/conversations')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;

            const getConversationsQuery = `
                SELECT * FROM conversations WHERE (userID1 = ? OR userID2 = ?) AND convLastMessage IS NOT NULL ORDER BY convCreatedAt DESC`;
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
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
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
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
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
                VALUES (?, ?, CURRENT_TIMESTAMP)
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


router.route('/messages')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const convID = req.query.convID;
            const startIndex = parseInt(req.query.startIndex) || 0;

            // Vérifies si l'utilisateur fait partie de la conversation ;)
            const checkConversationQuery = `
                SELECT *
                FROM conversations
                WHERE (userID1 = ? OR userID2 = ?) AND convID = ?
            `;
            const conversationResult = await executeQuery(checkConversationQuery, [userID, userID, convID]);

            if (conversationResult.length === 0) {
                const response = {
                        error : true,
                        error_message : 'You are not part of this conversation.',
                        error_code : 26
                }
                return res.status(403).json(response);
            }

            // Charge les 40 derniers messages à partir de l'index spécifié :)
            const loadMessagesQuery = `
                SELECT *
                FROM messages
                WHERE convID = ?
                ORDER BY messageCreatedAt DESC
                LIMIT ?, 40`;
            const messagesResult = await executeQuery(loadMessagesQuery, [convID, startIndex]);

            const response = {
                messages : messagesResult,
                status : 200,
            }
            return res.status(200).json(response);

        } catch (error) {
            console.error('Error loading messages:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

module.exports = router;
