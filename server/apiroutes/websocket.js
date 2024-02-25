const express = require('express');
const http = require('http');
const socketManager = require('./utils/socketManager');
const { executeQuery } = require('./utils/database.js');

const app = express();
const server = http.createServer(app);
const io = socketManager(server);

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

// Initialisation du serveur Socket.io
server.listen(3000, () => {
    console.log('Server listening on port 3000');

    // On surveille les modifications de la table notifications
    watchNotifications();
});

module.exports = io;

//Du côté frontend il faut écouter cet événement newNotification pour réagir à l'arrivée de nouvelles notifications... Valentin à toi de jouer
