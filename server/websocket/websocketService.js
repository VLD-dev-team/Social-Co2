const socketIO = require('socket.io');
const { sendMessage } = require('../utils/messageHandler');
const verifyAuthToken = require('../utils/requireAuth');

class WebsocketService {
    constructor() {
        this.io = null;
    }

    initialize(server, allowedOrigins) {
        this.io = socketIO(server, {
          cors: {
            origin: allowedOrigins,
            methods: ["GET", "POST"]
          }
        });
    
        this.io.on('connection', (socket) => {
          console.log('Nouvel utilisateur connecté au socket - ID:', socket.id);
    
          socket.on('disconnect', () => {
            console.log('Utilisateur deconnecté du socket ID:', socket.id);
          });
    
          // En cas de messages reçus
          socket.on('sendMessage', async (data) => {
            try {
                // Vérification de l'authentification de l'utilisateur
                const userID = await verifyAuthTokenOnSocket(data.token);
    
                // Appel de la fonction sendMessage avec les données appropriées
                const result = await sendMessage(userID, data.receiver, data.message);
                
                // Émission d'événements au client une fois le message traité
                this.io.to(result.convID).emit('updateConv', {
                    convID: result.convID,
                    lastMessage: result.lastMessage,
                    unreadCount: result.unreadCount
                });
                this.io.to(result.convID).emit('newMessage', {
                    convID: result.convID,
                    lastMessage: result.lastMessage,
                    unreadCount: result.unreadCount
                });
    
                console.log(result);
            } catch (error) {
                console.error('Erreur lors de l\'envoi du message :', error);
                // Gérer les erreurs ici et émettre un événement d'erreur au client si nécessaire
                this.io.emit('sendMessageError', { error: 'Échec de l\'envoi du message' });
            }});
        });
      }
    
    emitMessage(channel, data) {
      if (this.io) {
        this.io.emit(channel, data);
        return true;
      } else {
        console.error('Socket.io is not initialized.');
        return false;
      }
    }
}

module.exports = WebsocketService;