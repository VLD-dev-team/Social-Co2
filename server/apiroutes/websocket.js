const express = require('express');
const initializeSocket = require('../utils/socketManager.js');
const { verifyAuthToken } = require('../utils/requireAuth.js');
const notificationHandler = require('../utils/notificationHandler.js');
const { sendMessage } = require('../utils/messageHandler.js');
const { createServer } = require("http");

const router = express.Router();

// Initialisation du serveur Socket.io
const server = createServer();
const io = initializeSocket(server);

router.use('/', (req, res, next) => {
    req.io = io;
    next();
});

io.on('connection', (socket) => {
    // Gestion de l'événement 'sendMessage'
    socket.on('sendMessage', async (data) => {
        try {
            // Vérification de l'authentification de l'utilisateur
            const userID = await verifyAuthToken(data.token);

            // Appel de la fonction sendMessage avec les données appropriées
            const result = await sendMessage(userID, data.receiver, data.message);
            
            // Émission d'événements au client une fois le message traité
            io.to(result.convID).emit('updateConv', {
                convID: result.convID,
                lastMessage: result.lastMessage,
                unreadCount: result.unreadCount
            });
            io.to(result.convID).emit('newMessage', {
                convID: result.convID,
                lastMessage: result.lastMessage,
                unreadCount: result.unreadCount
            });

            console.log(result);  // Vous pouvez supprimer cette ligne si vous n'avez pas besoin de l'afficher côté serveur
        } catch (error) {
            console.error('Error sending message:', error);
            // Gérer les erreurs ici et émettre un événement d'erreur au client si nécessaire
            socket.emit('sendMessageError', { error: 'Failed to send message' });
        }
    });
});

// On surveille les modifications de la table notifications
//notificationHandler.watchNotifications(io);

module.exports = router;
