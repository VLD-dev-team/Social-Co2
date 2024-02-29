const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/feed')
    .get(async (req, res) => {
        try {
            const userID = req.headers.id;

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

            return res.status(200).json({ feed: feedResult });
        } catch (error) {
            console.error('Error retrieving feed:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

router.route('/conversations')
    .get(async (req, res) => {
        try {
            const userID = req.headers.id;

            const getConversationsQuery = `
                SELECT * FROM conversations WHERE (userID1 = ? OR userID2 = ?) AND convLastMessage IS NOT NULL ORDER BY convCreatedAt DESC`;
            const conversationsResult = await executeQuery(getConversationsQuery, [userID, userID]);

            return res.status(200).json({ conversations: conversationsResult });
        } catch (error) {
            console.error('Error retrieving conversations:', error);
            return res.status(500).send('Internal Server Error');
        }
    })
    .post(async (req, res) => {
        try {
            const userID = req.headers.id;
            const friendID = req.body.friendID;

            // Vérifie le statut de l'amitié entre l'utilisateur et son ami
            const checkFriendshipQuery = `
                SELECT friendshipStatus FROM friends
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
            `;
            const checkFriendshipResult = await executeQuery(checkFriendshipQuery, [userID, friendID, friendID, userID]);
            // Si c'est 22 c'est ok :)
            if (checkFriendshipResult.length === 0 || checkFriendshipResult[0].friendshipStatus !== '22') {
                return res.status(400).send('Users are not friends or friendship status is not accepted. Conversation cannot be created.');
            }

            // Vérifie si une conversation existe déjà entre les deux utilisateurs, sinon on va pas s'embêter
            const checkConversationQuery = `
                SELECT convID FROM conversations
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
            `;
            const checkConversationResult = await executeQuery(checkConversationQuery, [userID, friendID, friendID, userID]);

            if (checkConversationResult.length > 0) {
                return res.status(400).send('Conversation already exists.');
            }

            // Créer la nouvelle conversation
            const createConversationQuery = `
                INSERT INTO conversations (userID1, userID2, convCreatedAt)
                VALUES (?, ?, CURRENT_TIMESTAMP)
            `;
            const createConversationResult = await executeQuery(createConversationQuery, [userID, friendID]);

            if (createConversationResult.affectedRows === 0) {
                return res.status(500).send('Failed to create conversation.');
            }

            return res.status(201).send('Conversation created successfully.');
        } catch (error) {
            console.error('Error creating conversation:', error);
            return res.status(500).send('Internal Server Error');
        }
    });


router.route('/messages')
    .get(async (req, res) => {
        try {
            const userID = req.headers.id;
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
                return res.status(403).send('You are not part of this conversation.');
            }

            // Charge les 40 derniers messages à partir de l'index spécifié :)
            const loadMessagesQuery = `
                SELECT *
                FROM messages
                WHERE convID = ?
                ORDER BY messageCreatedAt DESC
                LIMIT ?, 40`;
            const messagesResult = await executeQuery(loadMessagesQuery, [convID, startIndex]);

            return res.status(200).json({ messages: messagesResult });
        } catch (error) {
            console.error('Error loading messages:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

module.exports = router;
