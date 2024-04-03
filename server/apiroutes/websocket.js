// websocket.js

const express = require('express');
const { createServer } = require("http");
const socketManager = require('../utils/socketManager.js');

const router = express.Router();

// Initialisation du serveur Socket.io
const server = createServer();
const io = socketManager.initializeSocket(server);

router.use('/', (req, res, next) => {
    req.io = io;
    next();
});

module.exports = router;
