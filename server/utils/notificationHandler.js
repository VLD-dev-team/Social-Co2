const { executeQuery } = require('./database.js');

const handleNewNotification = async (io, notificationData) => {
    const { userID, notificationContent } = notificationData;

    // On émet la notification à l'utilisateur concerné via Socket.io
    io.to(userID).emit('newNotification', { notificationContent });

    // Mettre à jour le statut de la notification dans la base de données
    const updateNotificationQuery = `UPDATE notifications SET notificationStatus = 'send' WHERE userID = ? AND notificationContent = ? ;`;
    await executeQuery(updateNotificationQuery, [userID, notificationContent]);
};

module.exports = {
    handleNewNotification,
    // watchNotifications
};
