const socketIo = require('socket.io');
const { verifyAuthToken } = require('./requireAuth.js');
const { sendMessage } = require('./messageHandler.js');

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
    
                console.log(result);
            } catch (error) {
                console.error('Error sending message:', error);
                // Gérer les erreurs ici et émettre un événement d'erreur au client si nécessaire
                socket.emit('sendMessageError', { error: 'Failed to send message' });
            }
        });
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
