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

// On surveille les modifications de la table notifications
//notificationHandler.watchNotifications(io);

module.exports = router;
