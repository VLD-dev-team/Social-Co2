// socketManager.js

const socketIo = require('socket.io');
const { verifyAuthToken } = require('./requireAuth.js');
const { sendMessage } = require('./messageHandler.js');

let ioInstance;

// Fonction pour initialiser Socket.io avec le serveur Express
const initializeSocket = (server) => {
    ioInstance = socketIo(server);

    // Gestion des connexions
    ioInstance.on('connection', (socket) => {
        console.log('Utilisateur connecté :', socket.id);

        // Gestion des déconnexions
        socket.on('disconnect', () => {
            console.log('Utilisateur déconnecté :', socket.id);
        });

        socket.on('sendMessage', async (data) => {
            try {
                // Vérification de l'authentification de l'utilisateur
                const userID = await verifyAuthToken(data.token);
    
                // Appel de la fonction sendMessage avec les données appropriées
                const result = await sendMessage(userID, data.receiver, data.message);
                
                // Émission d'événements au client une fois le message traité
                ioInstance.to(result.convID).emit('updateConv', {
                    convID: result.convID,
                    lastMessage: result.lastMessage,
                    unreadCount: result.unreadCount
                });
                ioInstance.to(result.convID).emit('newMessage', {
                    convID: result.convID,
                    lastMessage: result.lastMessage,
                    unreadCount: result.unreadCount
                });
    
                console.log(result);
            } catch (error) {
                console.error('Erreur lors de l\'envoi du message :', error);
                // Gérer les erreurs ici et émettre un événement d'erreur au client si nécessaire
                socket.emit('sendMessageError', { error: 'Échec de l\'envoi du message' });
            }
        });
    });

    // Middleware pour ajouter le socket à la demande Express
    ioInstance.use((socket, next) => {
        const userID = socket.handshake.auth.userID;
        if (userID) {
            socket.userID = userID;
            return next();
        }
        return next(new Error('Erreur d\'authentification'));
    });

    return ioInstance;
};

// Fonction pour obtenir l'instance Socket.io initialisée
const getIO = () => {
    if (!ioInstance) {
        throw new Error('Socket.io n\'a pas été initialisé.');
    }
    return ioInstance;
};

module.exports = {
    initializeSocket,
    getIO
};
