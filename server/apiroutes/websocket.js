const express = require('express');
const socketManager = require('../utils/socketManager.js');
const { executeQuery } = require('../utils/database.js');
const notificationHandler = require('../utils/notificationHandler.js');
const messageHandler = require('../utils/messageHandler.js');

const router = express.Router();

// Initialisation du serveur Socket.io
const server = socketManager.createServer();
const io = socketManager.initializeSocket(server);

router.use('/', (req, res, next) => {
    req.io = io;
    next();
});

router.route('/send')
    .post(async (req, res) => {
        try {
            const senderID = req.headers.id;
            const receiverID = req.body.receiverID;
            const messageTextContent = req.body.messageTextContent;

            if (typeof senderID !== 'string' || typeof receiverID !== 'string' || typeof messageTextContent !== 'string') {
                return res.status(400).send('Invalid parameters');
            }

            const result = await messageHandler.sendMessage(io, senderID, receiverID, messageTextContent);
            return res.status(200).send(result);
        } catch (error) {
            console.error('Error in /send route:', error);
            return res.status(error.status || 500).send('Internal Server Error');
        }
    });

// On surveille les modifications de la table notifications
notificationHandler.watchNotifications(io);

// On surveille les modifications de la table messages
messageHandler.watchMessages(io);

module.exports = router;
