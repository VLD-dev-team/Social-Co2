const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');


router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));


router.route('/messages')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const convID = req.query.convid;
            const startIndex = parseInt(req.query.startIndex) || 0;

            // Vérifies si l'utilisateur fait partie de la conversation ;)
            const checkConversationQuery = `
                SELECT *
                FROM conversations
                WHERE (userID1 = ? OR userID2 = ?) AND convID = ? ;
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
                LIMIT ?, 40 ;`;
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
