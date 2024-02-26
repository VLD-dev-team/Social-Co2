const { executeQuery } = require('./utils/database.js');

// Fonction pour envoyer un message

const sendMessage = async (senderID, receiverID, messageTextContent) => {
    try {
        const checkFriendshipQuery = `
            SELECT friendshipStatus FROM friends
            WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
        `;
        const checkFriendshipResult = await executeQuery(checkFriendshipQuery, [senderID, receiverID, receiverID, senderID]);

        if (checkFriendshipResult.length === 0 || checkFriendshipResult[0].friendshipStatus !== '22') {
            // Si les utilisateurs ne sont pas amis ou le statut d'amitié n'est pas "22", renvoyer une erreur 400
            const error = new Error('Users are not friends or friendship status is not accepted. Conversation cannot be created.');
            error.status = 400;
            throw error;
        }

        const checkConversationQuery = `
            SELECT convID FROM conversations
            WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
        `;
        const checkConversationResult = await executeQuery(checkConversationQuery, [senderID, receiverID, receiverID, senderID]);

        if (checkConversationResult.length === 0) {
            const createConversationQuery = `
                INSERT INTO conversations (userID1, userID2, convCreatedAt)
                VALUES (?, ?, CURRENT_TIMESTAMP)
            `;
            const createConversationResult = await executeQuery(createConversationQuery, [senderID, receiverID]);

            if (createConversationResult.affectedRows === 0) {
                // Erreur 400 si la création de la conversation échoue
                const error = new Error('Failed to create conversation');
                error.status = 400;
                throw error;
            }
        }

        const convIDQuery = `
            SELECT convID FROM conversations
            WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
        `;
        const convIDResult = await executeQuery(convIDQuery, [senderID, receiverID, receiverID, senderID]);

        if (convIDResult.length === 0) {
            // Erreur 400 si l'obtention de l'ID de la conversation échoue
            const error = new Error('Failed to get conversation ID');
            error.status = 400;
            throw error;
        }

        const convID = convIDResult[0].convID;

        const insertMessageQuery = `
            INSERT INTO messages (convID, messageSenderID, messageTextContent, messageCreatedAt)
            VALUES (?, ?, ?, CURRENT_TIMESTAMP)
        `;
        const insertMessageResult = await executeQuery(insertMessageQuery, [convID, senderID, messageTextContent]);

        if (insertMessageResult.affectedRows === 0) {
            // Erreur 400 si l'insertion du message échoue
            const error = new Error('Failed to insert message');
            error.status = 400;
            throw error;
        }

        const createNotificationQuery = `
            INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus, notificationCreatedAt)
            VALUES (?, ?, ?, 'unread', CURRENT_TIMESTAMP)
        `;
        const createNotificationResult = await executeQuery(createNotificationQuery, [receiverID, 'New message received', 'New Message']);

        if (createNotificationResult.affectedRows === 0) {
            // Erreur 400 si la création de la notification échoue
            const error = new Error('Failed to create notification');
            error.status = 400;
            throw error;
        }

        return 'Message add successfully';
    } catch (error) {
        console.error('Error sending message:', error);
        throw error.status ? error : new Error('Internal Server Error');
    }
};

const handleNewMessage = async (io, messageData) => {
    const { convID, messageSenderID, messageTextContent } = messageData;

    // On émet le message à l'utilisateur concerné via Socket.io
    io.to(convID).emit('newMessage', { messageSenderID, messageTextContent });
};

const watchMessages = async (io) => {
    const messageWatcherQuery = `SELECT * FROM messages WHERE messageStatus = 'unread'`;

    const watcher = executeQuery(messageWatcherQuery);

    watcher.on('result', async (result) => {
        // À chaque fois qu'il y a un nouveau message non lu, on gère le message
        const messageData = {
            convID: result.convID,
            messageSenderID: result.messageSenderID,
            messageTextContent: result.messageTextContent
        };
        handleNewMessage(io, messageData);
    });
};

module.exports = {
    sendMessage,
    handleNewMessage,
    watchMessages
};
