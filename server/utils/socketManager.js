const socketIo = require('socket.io');

// Fonction pour initialiser Socket.io avec le serveur Express
const initializeSocket = (server) => {
    const io = socketIo(server);

    // Gestion des connexions
    io.on('connection', (socket) => {
        console.log('User connected:', socket.id);

        // Gestion des déconnexions
        socket.on('disconnect', () => {
            console.log('User disconnected:', socket.id);
        });

        // // Écoute des événements liés aux notifications
        // socket.on('notification', (notificationData) => {
        //     const { userID, notificationContent } = notificationData;
        //     io.to(userID).emit('newNotification', { notificationContent });
        // });
        // // Écoute des événements liés aux messages
        // socket.on('message', (messageData) => {
        //     const { convID, messageSenderID, messageTextContent } = messageData;
        //     io.to(convID).emit('newMessage', { messageSenderID, messageTextContent });
        // });
    });

    // Middleware pour ajouter le socket à la demande Express
    io.use((socket, next) => {
        const userID = socket.handshake.auth.userID;
        if (userID) {
            socket.userID = userID;
            return next();
        }
        return next(new Error('Authentication error'));
    });

    return io;
};

module.exports = initializeSocket;
