const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const { verifyAuthToken } = require('../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/conversations')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;

            // Requête pour récupérer les conversations de l'utilisateur
            const getConversationsQuery = `
                SELECT convID, userID1, userID2 
                FROM conversations 
                WHERE (userID1 = ? OR userID2 = ?) 
                AND convLastMessage IS NOT NULL 
                ORDER BY convCreatedAt DESC ;
            `;
            const conversationsResult = await executeQuery(getConversationsQuery, [userID, userID]);

            // Pour chaque conversation, récupérer le nombre de messages non lus
            for (let conversation of conversationsResult) {
                // Vérifier d'abord si l'amitié a un statut "22"
                const friendshipStatusQuery = `
                    SELECT friendshipStatus
                    FROM friends
                    WHERE (userID1 = ? AND userID2 = ? AND friendshipStatus = '22')
                    OR (userID1 = ? AND userID2 = ? AND friendshipStatus = '22');
                `;
                const friendshipStatusResult = await executeQuery(friendshipStatusQuery, [userID, conversation.userID1, userID, conversation.userID2]);

                // Si l'amitié est confirmée (statut "22"), récupérer le nombre de messages non lus
                if (friendshipStatusResult.length > 0) {
                    const getNbUnreadMessageQuery = `
                        SELECT COUNT(*) AS unreadCount
                        FROM messages
                        WHERE convID = ? 
                        AND messageStatus = 'unread';
                    `;
                    const getNbUnreadMessageQueryResult = await executeQuery(getNbUnreadMessageQuery, [conversation.convID]);
                    conversation.unreadMessages = getNbUnreadMessageQueryResult[0].unreadCount;
                } else {
                    // Si l'amitié n'est pas confirmée, marquer le nombre de messages non lus comme 0
                    conversation.unreadMessages = 0;
                }
            }

            const response = {
                conversations: conversationsResult,
                status: 200,
            }
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error retrieving conversations:', error);
            const response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            }
            return res.status(500).json(response);
        }
    });

module.exports = router;
