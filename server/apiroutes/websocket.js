const express = require('express');
const socketManager = require('./utils/socketManager');
const { executeQuery } = require('./utils/database.js');

const router = express.Router();

// Lorsqu'une nouvelle notification est ajoutée à la table notifications
const handleNewNotification = async (notificationData) => {
    const { userID, notificationContent } = notificationData;

    // On émet la notification à l'utilisateur concerné via Socket.io
    io.to(userID).emit('newNotification', { notificationContent });
};

// Fonction pour surveiller les modifications de la table notifications
const watchNotifications = async () => {
    const notificationWatcherQuery = `SELECT * FROM notifications WHERE notificationStatus = 'unread'`;

    const watcher = executeQuery(notificationWatcherQuery);
    
    watcher.on('result', async (result) => {
        // Chaque fois qu'il y a une nouvelle notification non lue, on gère la notification
        const notificationData = {
            userID: result.userID,
            notificationContent: result.notificationContent
        };
        handleNewNotification(notificationData);
    });
};

// Fonction pour envoyer un message
const sendMessage = async (senderID, receiverID, messageTextContent) => {
    try {
        // Vérifier l'existence d'une conversation entre senderID et receiverID
        const checkConversationQuery = `
            SELECT convID FROM conversations
            WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
        `;
        const checkConversationResult = await executeQuery(checkConversationQuery, [senderID, receiverID, receiverID, senderID]);

        if (checkConversationResult.length === 0) {
            // Si la conversation n'existe pas, la créer
            const createConversationQuery = `
                INSERT INTO conversations (userID1, userID2, convCreatedAt)
                VALUES (?, ?, CURRENT_TIMESTAMP)
            `;
            const createConversationResult = await executeQuery(createConversationQuery, [senderID, receiverID]);

            if (createConversationResult.affectedRows === 0) {
                throw new Error('Failed to create conversation');
            }
        }

        // Récupérer l'ID de la conversation
        const convIDQuery = `
            SELECT convID FROM conversations
            WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
        `;
        const convIDResult = await executeQuery(convIDQuery, [senderID, receiverID, receiverID, senderID]);

        if (convIDResult.length === 0) {
            throw new Error('Failed to get conversation ID');
        }

        const convID = convIDResult[0].convID;

        // Insérer le message dans la table messages
        const insertMessageQuery = `
            INSERT INTO messages (convID, messageSenderID, messageTextContent, messageCreatedAt)
            VALUES (?, ?, ?, CURRENT_TIMESTAMP)
        `;
        const insertMessageResult = await executeQuery(insertMessageQuery, [convID, senderID, messageTextContent]);

        if (insertMessageResult.affectedRows === 0) {
            throw new Error('Failed to insert message');
        }

        // Émettre le message à l'utilisateur concerné via Socket.io
        io.to(convID).emit('newMessage', { messageSenderID: senderID, messageTextContent });

        return 'Message sent successfully';
    } catch (error) {
        console.error('Error sending message:', error);
        throw new Error('Internal Server Error');
    }
};

// Initialisation du serveur Socket.io
const server = socketManager.createServer();
const io = socketManager.initializeSocket(server);

router.use('/', (req, res, next) => {
    req.io = io; // Ajouter l'instance de Socket.io à la demande Express
    next();
});

// Route pour envoyer un message
router.route('/send')
    .post( async (req, res) => {
    try {
        const senderID = req.headers.id;
        const receiverID = req.body.receiverID;
        const messageTextContent = req.body.messageTextContent;

        if (typeof senderID !== 'string' || typeof receiverID !== 'string' || typeof messageTextContent !== 'string') {
            return res.status(400).send('Invalid parameters');
        }

        const result = await sendMessage(senderID, receiverID, messageTextContent);
        return res.status(200).send(result);
    } catch (error) {
        console.error('Error in /send route:', error);
        return res.status(500).send('Internal Server Error');
    }
});

const handleNewMessage = async (messageData) => {
    const { convID, messageSenderID, messageTextContent } = messageData;

    // On émet le message à l'utilisateur concerné via Socket.io
    io.to(convID).emit('newMessage', { messageSenderID, messageTextContent });
};

// Fonction pour surveiller les modifications de la table messages
const watchMessages = async () => {
    const messageWatcherQuery = `SELECT * FROM messages WHERE messageStatus = 'unread'`;

    const watcher = executeQuery(messageWatcherQuery);

    watcher.on('result', async (result) => {
        // À chaque fois qu'il y a un nouveau message non lu, on gère le message
        const messageData = {
            convID: result.convID,
            messageSenderID: result.messageSenderID,
            messageTextContent: result.messageTextContent
        };
        handleNewMessage(messageData);
    });
};


// On surveille les modifications de la table notifications
watchNotifications();
// On surveille les modifications de la table messages
watchMessages();


module.exports = router;

//Du côté frontend il faut écouter cet événement newNotification pour réagir à l'arrivée de nouvelles notifications... Valentin à toi de jouer
