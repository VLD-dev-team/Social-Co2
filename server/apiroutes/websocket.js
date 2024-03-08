const express = require('express');
const initializeSocket = require('../utils/socketManager.js');
const { createServer } = require("http");

const router = express.Router();

// Initialisation du serveur Socket.io
const server = createServer();
const io = initializeSocket(server);

router.use('/', (req, res, next) => {
    req.io = io;
    next();
});


module.exports = router;
