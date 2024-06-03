const { executeQuery } = require('../utils/database.js');
const socketManager = require('../websocketHandler/socketManager.js');

const newNotif = async (notificationData) => {
    const { userID, notificationContent } = notificationData;

    let WebsocketServiceInstance = require('../websocket/websocketService.js');

    // On émet la notification à l'utilisateur concerné via Socket.io
    WebsocketServiceInstance.emit('newNotification', { notificationContent });

    // Mettre à jour le statut de la notification dans la base de données
    const updateNotificationQuery = `UPDATE notifications SET notificationStatus = 'send' WHERE userID = ? AND notificationContent = ? ;`;
    await executeQuery(updateNotificationQuery, [userID, notificationContent]);
};

module.exports = {
    newNotif,
    // watchNotifications
};
